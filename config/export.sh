source ~/.bashrc.d/function.d/export.sh

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home"
export ANDROID_HOME="~/Library/Android/sdk"

addToPath $HOME/bin
addToPath /usr/local/bin
addToPath ~/.bashrc.d/function.d
addToPath /Users/kpr/Library/Android/sdk/platform-tools
addToPath /Users/kpr/Library/Android/sdk/tools
addToPath ~/mongo/mongodb-3.2.18/bin
addToPath /usr/local/Cellar/plantuml/1.2018.1/libexec/plantuml.jar

sourceIt ~/.bashrc.d/emsdk_set_env.sh
sourceIt $HOME/.cargo/env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
