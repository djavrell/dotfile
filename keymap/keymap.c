#include QMK_KEYBOARD_H

#include "version.h"
#include "keymap_french.h"

#include "features/mouse_turbo_click.h"
#include "config.h"

enum custom_keycodes {
    RP_FIRE = SAFE_RANGE,
};

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
[0] = LAYOUT_ergodox_pretty(
  KC_NO,    KC_F1,    KC_F2,  KC_F3,    KC_F4,    KC_F5,  KC_NO,              KC_NO,    KC_F6,  KC_F7,    KC_F8,    KC_F9,    KC_F10,         KC_F11,
  KC_NO,    FR_A,     FR_Z,   FR_E,     FR_R,     FR_T,   KC_NO,              KC_NO,    FR_Y,   FR_U,     FR_I,     FR_O,     FR_P,           KC_NO,
  KC_NO,    FR_Q,     FR_S,   LT3_D,    LT1_F,    FR_G,                                 FR_H,   LT1_J,    FR_K,     FR_L,     FR_M,           KC_NO,
  KC_LSFT,  FR_W,     FR_X,   FR_C,     FR_V,     FR_B,   KC_NO,              TG(2),    FR_N,   FR_COMM,  FR_SCLN,  FR_COLN,  CTL_T(FR_EXLM), KC_NO,
  KC_NO,    KC_NO,    KC_NO,  KC_LEFT,  KC_RGHT,                                                KC_UP,    KC_DOWN,  KC_NO,    KC_NO,          KC_NO,
                                                KC_RALT,  KC_DEL,             KC_PGUP,  KC_LALT,
                                                          KC_HOME,            KC_PGDN,
                                        MT1_SHS, MT1_ABS, KC_ESC,             KC_NO,    MT2_CTB, MT2_AEN
),
[1] = LAYOUT_ergodox_pretty(
  _______, _______, _______, _______, _______,  _______, _______,     _______, _______, _______,  _______,  _______,  _______,  _______,
  _______, FR_EXLM, FR_AT,   FR_LPRN, FR_LABK,  FR_PIPE, _______,     _______, _______, _______,  _______,  _______,  _______,  _______,
  _______, FR_HASH, FR_DLR,  FR_LCBR, _______,  FR_GRV,                        _______, _______,  _______,  _______,  _______,  _______,
  _______, FR_PERC, FR_CIRC, FR_LBRC, _______,  FR_TILD, _______,     _______, _______, _______,  _______,  _______,  _______,  _______,
  _______, _______, _______, _______, _______,                                          _______,  _______,  _______,  _______,  _______,
                                               RGB_MOD, _______,     _______, _______,
                                                        _______,     _______,
                                       KC_SPC, KC_BSPC, _______,     _______, _______, _______
),
[2] = LAYOUT_ergodox_pretty(
  _______, _______, _______, _______,   _______,  _______, _______,     _______, _______, _______, _______, _______, _______, _______,
  _______, _______, KC_UP  , _______,   _______,  _______, _______,     _______, _______, _______, _______, _______, _______, _______,
  _______, KC_LEFT, KC_DOWN, KC_RIGHT,  _______,  _______,                       KC_BTN1, KC_BTN1, KC_BTN2, RP_FIRE, _______, _______,
  _______, _______, _______, _______,   _______,  _______, _______,     _______, _______, _______, _______, _______, _______, _______,
  _______, _______, _______, _______,   _______,                                          _______, _______, _______, _______, _______,

                                               _______, QK_BOOT,     _______, _______,
                                                        _______,     _______,
                                      _______, _______, _______,     _______, _______, KC_WBAK
),
[3] = LAYOUT_ergodox_pretty(
  _______, _______, _______, _______, _______,  _______, _______,     _______, _______, _______,  _______,  _______,  _______,  _______,
  _______, _______, _______, _______, _______,  _______, _______,     _______, _______, FR_7,     FR_8,     FR_9,     FR_ASTR,  _______,
  _______, _______, _______, _______, _______,  _______,                       _______, FR_4,     FR_5,     FR_6,     FR_PLUS,  _______,
  _______, _______, _______, _______, _______,  _______, _______,     _______, _______, FR_1,     FR_2,     FR_3,     FR_BSLS,  _______,
  _______, _______, _______, _______, _______,                                          _______,  _______,  FR_0,     FR_EQL,   _______,
                                                _______, _______,     _______, _______,
                                                         _______,     _______,
                                       _______, _______, _______,     _______, _______, _______
),
};
// clang-format on

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  if (!process_mouse_turbo_click(keycode, record, RP_FIRE)) { return false; }
  return true;
}

// Runs just one time when the keyboard initializes.
void keyboard_post_init_user(void) {
#ifdef RGBLIGHT_COLOR_LAYER_0
    rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
#endif
    // debug_enable=true;
    // debug_keyboard=true;
    // debug_matrix=true;
};
