#pragma once

#define COMBO_TERM 80

#define POINTING_DEVICE_INVERT_X
#define POINTING_DEVICE_INVERT_Y

// Layer switching
// F and J are lso used in combo mapping for à, ù, è
#define LT1_F LT(SYMB, FR_F)
#define LT1_J LT(SYMB, FR_J)

// Tap-Hold keys
#define MT1_SHS MT(MOD_LSFT, KC_SPC)
#define MT1_CBS MT(MOD_LCTL, KC_BSPC)

enum layers {
    BASE,  // default layer
    SYMB,  // symbols
    MDIA,  // media keys
};
