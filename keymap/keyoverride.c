#include QMK_KEYBOARD_H
#include "keymap_french.h"

#define CS(trigger, replacement) &ko_make_basic(MOD_MASK_SHIFT, trigger, replacement)

const key_override_t **key_overrides = (const key_override_t *[]){
  // CS(KC_BSPC, KC_DEL),
  // CS(FR_COLN, FR_SCLN),
  // CS(FR_QUOT, FR_DQUO),
  // CS(FR_BSLS, FR_PIPE),
  // CS(FR_COMM, FR_LABK),
  // CS(FR_DOT, FR_RABK),
  // CS(FR_SLSH, FR_QUES),
  // CS(FR_MINS, FR_UNDS),
  // CS(FR_GRV, FR_TILD),
  NULL
};
