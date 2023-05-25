# Python
pythonPath="/Library/Frameworks/Python.framework"
pythonVersion=$(basename $pythonPath/Versions/* | tail -1)

path=( "$pythonPath/Versions/$pythonVersion/bin" $path )
