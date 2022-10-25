#include QMK_KEYBOARD_H
#include "keymap_french.h"
#include "config.h"

#define COMB(cb, replace)   COMBO(combos_map[cb], replace)
#define COMBA(cb)           COMBO_ACTION(combos_map[cb])

// left   -> use right combo key
//  a e
// right  -> use letf combo key
//  i o u

#define R_CIR   FR_H  // ê
#define R_ACU   LT1_J // é
#define R_GRV   FR_K  // è
#define R_TRM   FR_L  // ë

#define L_CIR   FR_G
#define L_ACU   LT1_F
#define L_GRV   FR_D  // ù
#define L_TRM   FR_S

#define X_CIRC  X_LBRACKET

enum combo_keys {
  // à, è, ù
  CB_A_GRV,
  CB_E_GRV,
  CB_U_GRV,

  // é
  CB_E_ACU,

  // ë, ä, ï, ö, ü
  CB_A_TRM,
  CB_E_TRM,
  CB_I_TRM,
  CB_O_TRM,
  CB_U_TRM,

  // â, ê, î, ô, û
  CB_A_CIR,
  CB_E_CIR,
  CB_I_CIR,
  CB_O_CIR,
  CB_U_CIR,

  // ç

  COMBO_LENGTH,
};

