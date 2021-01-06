# Git
gitVersion=$(basename /usr/local/Cellar/git/*)
export PERL5LIB="/usr/local/Cellar/git/$gitVersion/share/perl5:$PERL5LIB"

# Python
pythonVersion=$(basename /Users/kpr/Library/Python/* | tail -1)
path=( "/Users/kpr/Library/Python/$pythonVersion/bin" $path )

# JAVA
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home"

load "$SYSFILE/gruvbox_256palette_osx.sh"
