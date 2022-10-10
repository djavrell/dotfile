#include QMK_KEYBOARD_H
#include "keymap_french.h"

#define COMB(cb, replace)  COMBO(combos_map[cb], replace)

#define R_ACU  FR_J    // '

enum combo_keys {
  CB_E_ACU,
  COMBO_LENGTH,
};

