#include QMK_KEYBOARD_H

#include "keymap_french.h"
#include "config.h"
#include "combo.h"

const uint16_t COMBO_LEN = COMBO_LENGTH;

const uint16_t PROGMEM combos_map[][3] = {
  [CB_E_GRV] = { R_GRV, FR_E, COMBO_END },
  [CB_A_GRV] = { R_GRV, FR_A, COMBO_END },
  [CB_U_GRV] = { L_GRV, FR_U, COMBO_END },

  [CB_E_ACU] = { R_ACU, FR_E, COMBO_END },

  [CB_A_TRM] = { L_TRM, FR_A, COMBO_END },
  [CB_E_TRM] = { L_TRM, FR_E, COMBO_END },
  [CB_I_TRM] = { R_TRM, FR_I, COMBO_END },
  [CB_O_TRM] = { R_TRM, FR_O, COMBO_END },
  [CB_U_TRM] = { R_TRM, FR_U, COMBO_END },

  [CB_A_CIR] = { L_CIR, FR_A, COMBO_END },
  [CB_E_CIR] = { L_CIR, FR_E, COMBO_END },
  [CB_I_CIR] = { R_CIR, FR_I, COMBO_END },
  [CB_O_CIR] = { R_CIR, FR_O, COMBO_END },
  [CB_U_CIR] = { R_CIR, FR_U, COMBO_END },
};

combo_t key_combos[] = {
  COMB(CB_E_GRV, FR_EGRV),
  COMB(CB_A_GRV, FR_AGRV),
  COMB(CB_U_GRV, FR_UGRV),

  COMB(CB_E_ACU, FR_EACU),

  COMBA(CB_A_TRM),
  COMBA(CB_E_TRM),
  COMBA(CB_I_TRM),
  COMBA(CB_O_TRM),
  COMBA(CB_U_TRM),

  COMBA(CB_A_CIR),
  COMBA(CB_E_CIR),
  COMBA(CB_I_CIR),
  COMBA(CB_O_CIR),
  COMBA(CB_U_CIR),
};

char* getTapKC(combo_t *combo) {
  uint16_t key = pgm_read_word(&combo->keys[1]);
  switch (key) {
    case FR_A:
      return SS_TAP(X_A);
    case FR_E:
      return SS_TAP(X_E);
    case FR_I:
      return SS_TAP(X_I);
    case FR_O:
      return SS_TAP(X_O);
    case FR_U:
      return SS_TAP(X_U);
    default:
      return "\0";
  }
}

void process_combo_event(uint16_t combo_index, bool pressed) {
  switch(combo_index) {
    case CB_A_TRM:
    case CB_E_TRM:
    case CB_I_TRM:
    case CB_O_TRM:
    case CB_U_TRM:
      if (pressed) {
        const char* x_code = getTapKC(&key_combos[combo_index]);
        SEND_STRING(SS_TAP(X_CIRC));
        send_string(x_code);
      }
      break;
    case CB_A_CIR:
    case CB_E_CIR:
    case CB_I_CIR:
    case CB_O_CIR:
    case CB_U_CIR:
      if (pressed) {
        const char* x_code = getTapKC(&key_combos[combo_index]);
        SEND_STRING(SS_LSFT(SS_TAP(X_CIRC)));
        send_string(x_code);
      }
      break;
  }
}
