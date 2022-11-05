SRC += led.c
SRC += keyoverride.c
SRC += combo.c

SRC += features/mouse_turbo_click.c

# CONSOLE_ENABLE          = yes
KEY_OVERRIDE_ENABLE     = yes
COMBO_ENABLE            = yes
POINTING_DEVICE_ENABLE  = yes
POINTING_DEVICE_DRIVER  = pimoroni_trackball
MOUSEKEY_ENABLE         = yes
DEFERRED_EXEC_ENABLE    = yes
