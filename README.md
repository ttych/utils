# Contents overview

composed of 2 kind of files :
- *.lib : supposed to be loaded in environment
- *.sh : script to be called directly from shell

# Setup

let's install this to $HOME/utils :
```
git clone https://github.com/ttych/utils.git "$HOME/utils"
cd "$HOME/utils"
make
```

Add "$HOME/utils/bin" to you PATH.
```
export PATH="$HOME/utils/bin:$PATH"
```

# Details

## pyv.lib

python virtual environment wrapper.
