#include QMK_KEYBOARD_H
#include "keymap_french.h"
#include "config.h"

#define COMB(cb, replace)   COMBO(combos_map[cb], replace)
#define COMBA(cb)           COMBO_ACTION(combos_map[cb])

#define L_ACU   LT1_J // è
#define L_GRV   FR_K  // é
#define L_CIRC  FR_L  // ê
#define L_TRM   FR_M  // ë

#define R_ACU   LT1_F
#define R_GRV   FR_D
#define R_CIRC  FR_S
#define R_TRM   FR_Q

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
  /* CB_A_CIR,
  CB_E_CIR,
  CB_I_CIR,
  CB_O_CIR,
  CB_U_CIR, */

  // ç
  COMBO_LENGTH,
};

