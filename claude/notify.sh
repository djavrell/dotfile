#!/usr/bin/env bash
# Usage : notify.sh, le JSON du hook (Notification ou Stop) sur stdin ; un argument éventuel est ignoré.
# Titre : le titre de la session (/rename, sinon celui généré), à défaut le dossier du projet.
# Corps : ce qui bloque Claude (l'outil à autoriser, sa question).
hook_json=$(cat)
hook_field() { jq -r "$1 // empty" <<<"$hook_json" 2>/dev/null; }

transcript=$(hook_field .transcript_path)
cwd=$(hook_field .cwd)
event=$(hook_field .hook_event_name)
notification_type=$(hook_field .notification_type)

session_title() {
  [ -f "$transcript" ] || return
  local entry title
  # Un titre donné par /rename prime sur celui généré ; la dernière occurrence fait foi.
  for entry in custom-title:customTitle ai-title:aiTitle; do
    title=$(grep -F "\"type\":\"${entry%%:*}\"" "$transcript" | tail -n1 | jq -r ".${entry##*:} // empty" 2>/dev/null)
    [ -n "$title" ] && { echo "$title"; return; }
  done
}

# La dernière demande d'outil du transcript : c'est elle qui attend l'autorisation.
pending_tool() {
  [ -f "$transcript" ] || return
  tac "$transcript" | grep -m1 -F '"type":"tool_use"' |
    jq -r '[.message.content[] | select(.type == "tool_use")] | last
      | if .name == "AskUserQuestion" then "Question : \(.input.questions[0].question // "")"
        else "Autoriser ? \(.name) : \(.input.command // .input.file_path // .input.url // .input.description // .input.pattern // "")"
        end' 2>/dev/null
}

# Ne notifie que si Claude est bloqué : une autorisation, une question (outil, serveur MCP, ou fin de réponse).
# idle_prompt est écarté : il part après chaque tour resté sans réponse, ce qui revient à un toast par tour.
case "$event:$notification_type" in
  Notification:permission_prompt)
    body=$(pending_tool)
    [ -z "$body" ] && body=$(hook_field .message) ;;
  Notification:elicitation_*)
    body=$(hook_field .message) ;;
  Stop:*)
    # La dernière ligne non vide de la réponse, gardée seulement si c'est une question.
    body=$(hook_field .last_assistant_message | grep -v '^[[:space:]]*$' | tail -n1)
    ends_with_question='\?[[:space:]*_`]*$'   # "?" suivi au plus d'espaces ou de markdown (**, _, `)
    [[ "$body" =~ $ends_with_question ]] || exit 0 ;;
  *)
    exit 0 ;;
esac
[ -z "$body" ] && body="Claude a besoin de toi"

title=$(session_title)
[ -z "$title" ] && title=${cwd##*/}
[ -z "$title" ] && title="Claude Code"

# Un toast n'affiche que quelques lignes : on aplatit et on coupe.
body=$(tr -s '\n\t ' '   ' <<<"$body")
(( ${#body} > 220 )) && body="${body:0:217}..."
title="${title//\'/\'\'}"   # échappe les apostrophes pour PowerShell
body="${body//\'/\'\'}"

powershell.exe -NoProfile -Command "
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType=WindowsRuntime] > \$null
\$t = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
\$x = \$t.GetElementsByTagName('text')
\$x[0].AppendChild(\$t.CreateTextNode('$title')) > \$null
\$x[1].AppendChild(\$t.CreateTextNode('$body')) > \$null
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe').Show([Windows.UI.Notifications.ToastNotification]::new(\$t))
" >/dev/null 2>&1 &
