#!/bin/sh

source "./installer/global/install_$SYSTEM.sh"

install_PM
global_update
install_packages
