#include QMK_KEYBOARD_H

#include "keymap_french.h"
#include "config.h"
#include "combo.h"

const uint16_t COMBO_LEN = COMBO_LENGTH;

const uint16_t PROGMEM combos_map[][3] = {
  [CB_E_GRV] = { L_GRV, FR_E, COMBO_END },
  [CB_A_GRV] = { L_GRV, FR_A, COMBO_END },
  [CB_U_GRV] = { R_GRV, FR_U, COMBO_END },

  [CB_E_ACU] = { L_ACU, FR_E, COMBO_END },
};

combo_t key_combos[] = {
  COMB(CB_E_GRV, FR_EGRV),
  COMB(CB_A_GRV, FR_AGRV),
  COMB(CB_U_GRV, FR_UGRV),

  COMB(CB_E_ACU, FR_EACU),
};

char* getTapKC(combo_t *combo) {
  uint16_t key = pgm_read_word(&combo->keys[1]);
}

void process_combo_event(uint_16t combo_index, bool pressed) {
  switch(combo_index) {
    /* case CB_A_TRM:
    case CB_E_TRM:
    case CB_I_TRM:
    case CB_O_TRM:
    case CB_U_TRM:
      if (pressed) {
      }
      break; */
    /* case CB_A_CIR:
    case CB_E_CIR:
    case CB_I_CIR:
    case CB_O_CIR:
    case CB_U_CIR:
      break; */
  }
}
