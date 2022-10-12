#include QMK_KEYBOARD_H

#include "keymap_french.h"
#include "combo.h"

const uint16_t COMBO_LEN = COMBO_LENGTH;

const uint16_t PROGMEM combos_map[][3] = {
  [CB_E_ACU] = { LT1_J, FR_E, COMBO_END },
  [CB_A_ACU] = { LT1_J, FR_A, COMBO_END },
  [CB_U_ACU] = { LT1_F, FR_U, COMBO_END },
};

combo_t key_combos[] = {
  COMB(CB_E_ACU, FR_EGRV),
  COMB(CB_A_ACU, FR_AGRV),
  COMB(CB_U_ACU, FR_UGRV),
};
