## Setup steps

1. Install Homebrew

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

2. Install Git

`brew install git`

3. Add SSH Key

`ssh-keygen -t ed25519 -C "email@example.com" | pbcopy`

3. Clone this repo

`git clone git@github.com:apledger/Scripts.git`

4. Run setup script

`/bin/bash ~/Scripts/setup.sh`
