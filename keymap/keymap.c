#include QMK_KEYBOARD_H
#include "version.h"

#include "keymap_french.h"

#include "tap_dance.h"

enum layers {
    BASE,  // default layer
    SYMB,  // symbols
    MDIA,  // media keys
};

// Layer switching
#define LT1_F LT(SYMB, FR_F)
#define LT1_J LT(SYMB, FR_J)

// Tap-Hold keys
#define MT1_SHS MT(MOD_LSFT, KC_SPC)
#define MT1_CBS MT(MOD_LCTL, KC_BSPC)

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
[BASE] = LAYOUT_ergodox_pretty(
  KC_NO,    KC_F1,        KC_F2,  KC_F3,    KC_F4,    KC_F5,  KC_NO,              KC_NO,    KC_F6,  KC_F7,    KC_F8,    KC_F9,    KC_F10,         KC_F11,
  KC_NO,    FR_A,         FR_Z,   FR_E,     FR_R,     FR_T,   TG(SYMB),           TG(SYMB), FR_Y,   FR_U,     FR_I,     FR_O,     FR_P,           KC_BSLS,
  KC_NO,    FR_Q,         FR_S,   FR_D,     LT1_F,    FR_G,                                 FR_H,   LT1_J,    FR_K,     FR_L,     FR_M,           GUI_T(KC_QUOT),
  KC_LSFT,  CTL_T(FR_W),  FR_X,   FR_C,     FR_V,     FR_B,   ALL_T(KC_NO),       TG(MDIA), FR_N,   FR_COMM,  FR_SCLN,  FR_COLN,  CTL_T(FR_EXLM), KC_RSFT,
  KC_NO,    KC_NO,        KC_NO,  KC_LEFT,  KC_RGHT,                                                KC_UP,    KC_DOWN,  KC_NO,    KC_NO,          KC_NO,
                                                    KC_RALT,  KC_DEL,             KC_LALT, KC_NO,
                                                              KC_HOME,            KC_PGUP,
                                            MT1_SHS, MT1_CBS, KC_ESC,             KC_PGDN, KC_TAB, KC_ENT
),
[SYMB] = LAYOUT_ergodox_pretty(
  _______, _______, _______, _______, _______,  _______, _______,     _______, _______, _______,  _______,  _______,  _______,  _______,
  _______, FR_EXLM, FR_AT,   TD_CBR,  TD_ABK,   FR_PIPE, _______,     _______, KC_NO,   FR_7,     FR_8,     FR_9,     FR_ASTR,  _______,
  _______, FR_HASH, FR_DLR,  TD_PRN,  _______,  FR_GRV,                        KC_NO,   FR_4,     FR_5,     FR_6,     FR_PLUS,  _______,
  _______, FR_PERC, FR_CIRC, TD_BRC,  _______,  FR_TILD, _______,     _______, KC_NO,   FR_1,     FR_2,     FR_3,     KC_BSLS,  _______,
  _______, _______, _______, _______, _______,                                          _______,  _______,  FR_0,     KC_EQL,   _______,
                                               RGB_MOD, _______,     RGB_TOG, RGB_M_P,
                                                        _______,     _______,
                                       KC_SPC, KC_BSPC, _______,     _______, RGB_HUD, RGB_HUI
),
[MDIA] = LAYOUT_ergodox_pretty(
  _______, _______, _______, _______, _______,  _______, _______,     _______, _______, _______, _______, _______, _______, _______,
  _______, _______, _______, KC_UP  , _______,  _______, _______,     _______, _______, _______, _______, _______, _______, _______,
  _______, _______, KC_LEFT, KC_DOWN, KC_RIGHT, _______,                       KC_BTN1, KC_BTN1, KC_BTN2, _______, _______, KC_MPLY,
  _______, _______, _______, _______, _______,  _______, _______,     _______, _______, _______, _______, _______, _______, _______,
  _______, _______, _______, KC_BTN1, KC_BTN2,                                         _______, _______, _______, _______, _______,

                                               _______, RESET  ,     _______, _______,
                                                        _______,     _______,
                                      _______, _______, _______,     _______, _______, KC_WBAK
),
};
// clang-format on

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    return true;
}

// Runs just one time when the keyboard initializes.
void keyboard_post_init_user(void) {
#ifdef RGBLIGHT_COLOR_LAYER_0
    rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
#endif
};

