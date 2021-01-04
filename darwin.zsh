COLORS="$DOTFILE/gruvbox_256palette_osx.sh"

# Git
gitVersion=$(basename /usr/local/Cellar/git/*)
export PERL5LIB="/usr/local/Cellar/git/$gitVersion/share/perl5:$PERL5LIB"

# Python
path=( "/Users/kpr/Library/Python/3.7/bin" $path )

# JAVA
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home"


test -f $COLORS && . $COLORS
