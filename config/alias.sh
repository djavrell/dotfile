for file in ~/.bashrc.d/alias.d/*.bashrc
do
	sourceIt "$file"
done
