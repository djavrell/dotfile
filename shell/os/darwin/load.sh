COLORS="$SYSTEM_FOLDER/gruvbox_256palette_osx.sh"

test -f $COLORS && . $COLORS

# Python
path=( "/Users/kpr/Library/Python/3.7/bin" $path )

# JAVA
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home"
