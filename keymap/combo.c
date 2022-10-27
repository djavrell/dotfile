#include QMK_KEYBOARD_H

#include "print.h"

#include "keymap_french.h"
#include "config.h"
#include "combo.h"

const uint16_t COMBO_LEN = COMBO_LENGTH;

const uint16_t PROGMEM combos_map[][3] = {
  [CB_E_GRV] = { R_GRV, FR_E, COMBO_END },
  [CB_A_GRV] = { R_GRV, FR_A, COMBO_END },
  [CB_U_GRV] = { L_GRV, FR_U, COMBO_END },

  [CB_E_ACU] = { R_ACU, FR_E, COMBO_END },

  [CB_A_TRM] = { R_TRM, FR_A, COMBO_END },
  [CB_E_TRM] = { R_TRM, FR_E, COMBO_END },
  [CB_I_TRM] = { L_TRM, FR_I, COMBO_END },
  [CB_O_TRM] = { L_TRM, FR_O, COMBO_END },
  [CB_U_TRM] = { L_TRM, FR_U, COMBO_END },

  [CB_A_CIR] = { R_CIR, FR_A, COMBO_END },
  [CB_E_CIR] = { R_CIR, FR_E, COMBO_END },
  [CB_I_CIR] = { L_CIR, FR_I, COMBO_END },
  [CB_O_CIR] = { L_CIR, FR_O, COMBO_END },
  [CB_U_CIR] = { L_CIR, FR_U, COMBO_END },
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

const char* tap[] = {
  [FR_A] = SS_TAP(X_Q),
  [FR_E] = SS_TAP(X_E),
  [FR_I] = SS_TAP(X_I),
  [FR_O] = SS_TAP(X_O),
  [FR_U] = SS_TAP(X_U),
};

const char* getTapKC(combo_t *combo) {
  uint16_t code = pgm_read_word(&combo->keys[1]);
  if (code < FR_A && code > FR_U) {
    return "\0";
  }
  return tap[code];
}

void process_combo_event(uint16_t combo_index, bool pressed) {
  if (pressed) {
    switch(combo_index) {
      case CB_A_TRM ... CB_U_TRM:
        SEND_STRING(SS_LSFT(SS_TAP(X_CIRC)));
        send_string(getTapKC(&key_combos[combo_index]));
        break;
      case CB_A_CIR ... CB_U_CIR:
        SEND_STRING(SS_TAP(X_CIRC));
        send_string(getTapKC(&key_combos[combo_index]));
        break;
    }
  }
}
