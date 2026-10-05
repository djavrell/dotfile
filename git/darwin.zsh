gitCellar="$(brew --prefix)/Cellar/git"
gitVersion=$(basename -a $gitCellar/* | tail -n1)
perlVersion=$(basename -a $gitCellar/$gitVersion/share/p* | tail -n1)

export PERL5LIB="$gitCellar/$gitVersion/share/$perlVersion:$PERL5LIB"
