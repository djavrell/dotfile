#include QMK_KEYBOARD_H
#include "keymap_french.h"
#include "config.h"

#define COMB(cb, replace)  COMBO(combos_map[cb], replace)

enum combo_keys {
  CB_E_ACU,
  CB_A_ACU,
  CB_U_ACU,
  COMBO_LENGTH,
};

