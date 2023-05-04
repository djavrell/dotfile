gitVersion=$(basename /opt/homebrew/Cellar/git/*)
export PERL5LIB="/opt/homebrew/Cellar/git/$gitVersion/share/perl3:$PERL5LIB"
