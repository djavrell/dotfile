#include QMK_KEYBOARD_H

#include "keymap_french.h"
#include "combo.h"

const uint16_t COMBO_LEN = COMBO_LENGTH;

const uint16_t PROGMEM combos_map[][3] = {
  [CB_E_ACU] = { R_ACU, FR_E, COMBO_END }
};

combo_t key_combos[] = {
  COMB(CB_E_ACU, FR_EACU)
};
