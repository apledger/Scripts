#!/bin/zsh

# Install Zsh if it isn't already the default shell
if [[ $SHELL != *"zsh"* ]]; then
  echo "Zsh is not the default shell. Installing Zsh..."
  brew install zsh
  chsh -s $(which zsh)
fi

# Install Oh My Zsh if it isn't already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is not installed. Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Set the Zsh theme to agnoster if it isn't already set
ZSH_THEME=$(grep 'ZSH_THEME=' $HOME/.zshrc | sed -e 's/ZSH_THEME="//' -e 's/"$//')
if [ "$ZSH_THEME" != "agnoster" ]; then
  echo "Setting Zsh theme to agnoster..."
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' $HOME/.zshrc
fi

# Install Powerline fonts
echo "Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# Instructions for the user to manually set the font in their terminal
echo "Please manually set one of the installed Powerline fonts in your terminal emulator's settings to take full effect."

# Install Oh My Zsh plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

# Add plugins to .zshrc if they aren't already there
if ! grep -q 'zsh-syntax-highlighting' $HOME/.zshrc; then
  sed -i '' '/^plugins=(git)/a\
  plugins+=(zsh-syntax-highlighting)
  ' $HOME/.zshrc
fi

if ! grep -q 'zsh-autosuggestions' $HOME/.zshrc; then
  sed -i '' '/^plugins=(git)/a\
  plugins+=(zsh-autosuggestions)
  ' $HOME/.zshrc
fi

echo "Installing Arc, Around, 1Password"
brew install arc
brew install around
brew install 1password

# Install fnm, node, and pnpm
echo "Installing Docker"
brew install --cask docker

# Install fnm, node, and pnpm
echo "Installing fnm and pnpm"
brew install fnm
echo 'eval "$(fnm env --use-on-cd)"' >> $HOME/.zshrc
fnm install --latest
brew install pnpm

# Add aliases
echo "Adding aliases"
echo 'alias p=pnpm' >> $HOME/.zshrc
echo 'alias ms="/bin/bash ~/Scripts/makeswift.sh"' >> $HOME/.zshrc

# Reload shell
source $HOME/.zshrc

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
brew install --cask visual-studio-code

# Final message to the user
echo "Installation complete!"