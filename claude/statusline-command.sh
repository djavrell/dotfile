#!/usr/bin/env bash
input=$(cat)

# ANSI color codes
CYAN=$'\e[36m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
BRIGHT_YELLOW=$'\e[93m'
MAGENTA=$'\e[35m'
PURPLE=$MAGENTA
BLUE=$'\e[34m'
RED=$'\e[31m'
DIM=$'\e[2m'
RESET=$'\e[0m'

# Single jq pass: one fork instead of ten, newline-delimited so paths with
# spaces survive intact. Order here must match the unpacking below.
mapfile -t f < <(printf '%s' "$input" | jq -r '
  [ (.model.display_name // "Claude"),
    (.context_window.used_percentage // 0),
    (((.context_window.total_input_tokens // 0)
      + (.context_window.total_output_tokens // 0)) | floor),
    (.context_window.context_window_size // 0),
    (if .rate_limits.five_hour then 1 else 0 end),
    (.rate_limits.five_hour.used_percentage // 0),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // 0),
    (.rate_limits.seven_day.resets_at // ""),
    (.cost.total_cost_usd // 0),
    (.vim.mode // ""),
    ((.cost.total_duration_ms // 0) | floor),
    (.effort.level // ""),
    (.workspace.current_dir // .cwd // ""),
    (if .prompt_cache then 1 else 0 end),
    (.prompt_cache.warm // false),
    (.prompt_cache.hit_ratio // -1),
    (.prompt_cache.misses // 0),
    (if .rate_limits.spend_limit then 1 else 0 end),
    (.rate_limits.spend_limit.used_percentage // 0)
  ] | .[] | tostring' 2>/dev/null)

model=${f[0]}
used=${f[1]}
used_tokens=${f[2]}
total_tokens=${f[3]}
has_limits=${f[4]}
h5_used=${f[5]}
h5_resets_at=${f[6]}
d7_used=${f[7]}
d7_resets_at=${f[8]}
cost=${f[9]}
vim_mode=${f[10]}
duration_ms=${f[11]}
effort=${f[12]}
cwd=${f[13]}
has_cache=${f[14]}
cache_warm=${f[15]}
cache_hit=${f[16]}
cache_misses=${f[17]}
has_spend=${f[18]}
spend_used=${f[19]}

# jq failed or gave us nothing usable -> fall back to safe defaults
: "${model:=Claude}" "${used:=0}" "${used_tokens:=0}" "${total_tokens:=0}"
: "${h5_used:=0}" "${d7_used:=0}" "${cost:=0}" "${duration_ms:=0}"
: "${has_cache:=0}" "${cache_hit:=-1}" "${cache_misses:=0}"
: "${has_spend:=0}" "${spend_used:=0}"

now_ts=$(date +%s)

# resets_at is documented as Unix epoch seconds; tolerate ISO-8601 just in case.
to_epoch() {
  case "$1" in
    ''|*[!0-9.]*) date -d "$1" +%s 2>/dev/null ;;
    *)            printf '%s' "${1%%.*}" ;;
  esac
}

# Countdown scaled to the window it describes: the 7d limit needs days, an
# imminent 5h reset reads better in bare minutes.
fmt_left() {
  if   [ "$1" -ge 86400 ]; then printf '%dd%dh'  $(( $1 / 86400 )) $(( ($1 % 86400) / 3600 ))
  elif [ "$1" -ge 3600  ]; then printf '%dh%02dm' $(( $1 / 3600 ))  $(( ($1 % 3600) / 60 ))
  else                          printf '%dm'      $(( $1 / 60 ))
  fi
}

# --- Context bar ---
# used_percentage may be fractional, so all rounding/clamping goes through awk.
BAR_LEN=16
read -r filled ctx_round < <(awk -v p="$used" -v n="$BAR_LEN" 'BEGIN{
  f = p * n / 100
  if (f > n) f = n
  if (f < 0) f = 0
  printf "%.0f %.0f", f, p
}')
empty=$(( BAR_LEN - filled ))
bar=""
for (( i = 0; i < filled; i++ )); do bar="${bar}${BRIGHT_YELLOW}█${YELLOW}"; done
for (( i = 0; i < empty; i++ )); do bar="${bar}░"; done
ctx_pct="${ctx_round}%"

# --- Rate limits (5h / 7d) ---
# Both windows side by side, each coloured on its own threshold. Thresholds go
# through awk because a fractional used_percentage (the API sends e.g. 23.5)
# made the old integer [ -ge ] tests error out and fall through to green.
# Absent entirely for non-subscribers and before the first API response.
limit_part=""
if [ "$has_limits" = "1" ]; then
  # The countdown goes to 7d only once it is actually under pressure (>=50%);
  # while both windows are comfortable the imminent 5h reset is more useful.
  read -r b5 r5 b7 r7 binding < <(awk -v a="$h5_used" -v b="$d7_used" 'BEGIN{
    printf "%d %.0f %d %.0f %d",
      (a >= 80 ? 2 : (a >= 50 ? 1 : 0)), a,
      (b >= 80 ? 2 : (b >= 50 ? 1 : 0)), b,
      (b > a && b >= 50 ? 7 : 5)
  }')
  case "$b5" in 2) c5=$RED ;; 1) c5=$YELLOW ;; *) c5=$GREEN ;; esac
  case "$b7" in 2) c7=$RED ;; 1) c7=$YELLOW ;; *) c7=$GREEN ;; esac

  # One countdown only, for whichever window is closest to its limit.
  if [ "$binding" = "7" ]; then binding_at=$d7_resets_at; else binding_at=$h5_resets_at; fi
  reset_str=""
  if [ -n "$binding_at" ]; then
    reset_ts=$(to_epoch "$binding_at")
    secs_left=$(( ${reset_ts:-0} - now_ts ))
    [ "$secs_left" -gt 0 ] && reset_str=" ${BLUE}↺ $(fmt_left "$secs_left")${RESET}"
  fi
  limit_part="  ${YELLOW}⚡${RESET} ${c5}${r5}%${RESET}${DIM}/${RESET}${c7}${r7}%${RESET}${reset_str}"
fi

# --- Gateway spend limit ---
# Only present behind a Claude apps gateway that enforces one, and it can read
# above 100 once the limit is blown, so the top band is >=100 rather than 80.
spend_part=""
if [ "$has_spend" = "1" ]; then
  read -r sp_band sp_round < <(awk -v s="$spend_used" 'BEGIN{
    printf "%d %.0f", (s >= 100 ? 3 : (s >= 80 ? 2 : (s >= 50 ? 1 : 0))), s
  }')
  case "$sp_band" in 3|2) cs=$RED ;; 1) cs=$YELLOW ;; *) cs=$GREEN ;; esac
  spend_part="  ${YELLOW}💳${RESET} ${cs}${sp_round}%${RESET}"
fi

# --- Reasoning effort ---
# Absent when the current model does not support the effort parameter.
case "$effort" in
  max|xhigh)  effort_part=" ${MAGENTA}🧠 ${effort}${RESET}" ;;
  high)       effort_part=" ${CYAN}🧠 ${effort}${RESET}" ;;
  low|medium) effort_part=" ${DIM}🧠 ${effort}${RESET}" ;;
  *)          effort_part="" ;;
esac

# --- Token counts ---
if [ "$used_tokens" -gt 0 ] 2>/dev/null && [ "$total_tokens" -gt 0 ] 2>/dev/null; then
  fmt_used=$(printf "%'d" "$used_tokens" 2>/dev/null || echo "$used_tokens")
  fmt_total=$(printf "%'d" "$total_tokens" 2>/dev/null || echo "$total_tokens")
  token_str="${fmt_used} / ${fmt_total} tokens"
else
  token_str="-- / -- tokens"
fi

# --- Prompt cache ---
# hit_ratio is a 0..1 fraction, null until the first response reports cache
# tokens, so -1 is the sentinel and the percentage is derived in awk.
# Absent entirely before the main conversation's first API response.
cache_part=""
if [ "$has_cache" = "1" ]; then
  if [ "$cache_warm" = "true" ]; then
    read -r hit_pct hit_band < <(awk -v h="$cache_hit" 'BEGIN{
      if (h < 0) { printf "-- 3"; exit }
      printf "%.0f %d", h * 100, (h >= 0.7 ? 0 : (h >= 0.4 ? 1 : 2))
    }')
    case "$hit_band" in
      0) cc=$GREEN ;;
      1) cc=$YELLOW ;;
      2) cc=$RED ;;
      *) cc=$DIM ;;
    esac
    cache_part="  ${cc}🗄 ${hit_pct}%${RESET}"
  else
    cache_part="  ${DIM}🗄 cold${RESET}"
  fi
  # Misses are the actionable figure: a prefix re-processed at full price with
  # no compaction to explain it. Counted for the main conversation only.
  if [ "$cache_misses" -gt 0 ] 2>/dev/null; then
    cache_part="${cache_part}${DIM}·${RESET}${RED}${cache_misses}✗${RESET}"
  fi
fi

# --- Vim mode ---
case "$vim_mode" in
  NORMAL) vim_part="${BLUE}[N]${RESET} " ;;
  INSERT) vim_part="${GREEN}[I]${RESET} " ;;
  VISUAL) vim_part="${PURPLE}[V]${RESET} " ;;
  *)      vim_part="" ;;
esac

# --- Session cost ---
cost_nonzero=$(awk "BEGIN{print ($cost > 0) ? 1 : 0}")
if [ "$cost_nonzero" = "1" ]; then
  cost_str=$(awk "BEGIN{printf \"\$%.4f\", $cost}")
  cost_part="  ${RED}💰 ${cost_str}${RESET}"
else
  cost_part=""
fi

# --- Git branch ---
# Branch name only: the staged/unstaged/untracked counts cost three more git
# invocations per render and that information is available elsewhere.
git_part=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_part="  ${GREEN}⎇ ${branch}${RESET}"
  else
    # Detached HEAD: no branch to name, so show the commit instead. Yellow
    # rather than green, because not being on a branch is worth noticing.
    sha=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    [ -n "$sha" ] && git_part="  ${YELLOW}⎇ ${sha}${RESET}"
  fi
fi

# --- Session elapsed time ---
# cost.total_duration_ms is wall-clock since the session started, so there is
# no need to track a start timestamp ourselves.
time_part=""
if [ "$duration_ms" -gt 0 ] 2>/dev/null; then
  elapsed=$(( duration_ms / 1000 ))
  if [ "$elapsed" -ge 3600 ]; then
    time_str="$(printf '%dh%02dm' $(( elapsed / 3600 )) $(( (elapsed % 3600) / 60 )))"
  else
    time_str="$(printf '%dm%02ds' $(( elapsed / 60 )) $(( elapsed % 60 )))"
  fi
  time_part="  ${MAGENTA}⏱ ${time_str}${RESET}"
fi

# --- Assemble ---
# Optional segments carry their own leading separator, so an absent one leaves
# no gap behind.
printf "%s${CYAN}🤖 %s${RESET}%s%s%s%s%s\n${YELLOW}[%s] %s  📊 %s${RESET}%s%s\n" \
  "$vim_part" "$model" "$effort_part" "$git_part" \
  "$limit_part" "$spend_part" "$cost_part" \
  "$bar" "$ctx_pct" "$token_str" "$cache_part" "$time_part"
