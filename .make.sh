#!/bin/bash
############################
# .make.sh
# This script will install all dependencies, 
# move the existing configuration files into a /old_comprc directory, 
# and symlink the configuration files into the home directory.
############################

########## Variables

dir=~/comprc2                                # dotfiles directory
olddir=~/comprc2_old                         # old dotfiles backup directory
files="zshrc vimrc vim tmux.conf"    # list of files/folders to symlink in homedir

##########

echo "Installing OS Dependencies"
if [[ $(uname -m) == 'arm64' ]]; then
  echo "Installing rosetta for apple M1"
	/usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi
	# Command line tools
	xcode-select --install

	# Homebrew and tools
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Install GNU core utilities (those that come with macOS are outdated).
	# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
	brew install coreutils
	ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

  brew bundle
	brew cleanup
echo "Finished Installing OS Dependencies"

# oh my zsh
echo "Installing Oh My Zsh"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Finished Installing Oh My Zsh"

# Change permissions on zsh files
sudo chown -R $(whoami):staff ~/.oh-my-zsh ~/.zsh*

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "Finished creating $olddir for backup of any existing dotfiles in ~"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "Finished changing to the $dir directory"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo "Moving any existing dotfiles from ~ to $olddir"
for file in $files; do
  mv ~/.$file $olddir
  echo "Creating symlink to $file in home directory."
  ln -s $dir/.$file ~/.$file
done
echo "Finished moving any existing dotfiles from ~ to $olddir"

# Install Plug for managing Vim plugins
echo "Installing Plug"
sudo curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Finished installing Plug"

# Change permissions on autload file
echo "Changing vim autoload permissions"
sudo chmod -R 755 ~/.vim/autoload
echo "Finished changing vim autoload permissions"

# Install the rest of the plugins
echo "Installing All Vim Plugins"
sudo vim +PlugInstall +qall
echo "Finished Installing All Vim Plugins"

 #Change permissions on autload file...already do this up above
#sudo chmod -R 755 ~/.vim/autoload

# Make fzf history public
echo "Changing fzf history permissions"
sudo chmod -R 755 ~/.local/share/fzf-history
echo "Finished changing fzf history permissions"

# Install NVM
echo "Installing NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

echo "Finished setting up NVM"


# add customizations
echo "Adding some paint....."
# pure prompt
npm install --global pure-prompt

# auto suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# configure git
echo "What email would you like to use for git?"
read git_email
git config --global user.email $git_email
git config --global core.excludesfile ~/.gitignore-global

#SSH stuff
echo "Follow the instructions below for creating a default SSH key"
ssh-keygen -t rsa
echo "Finished with customizations"

# switch to zsh shell
echo "Making zsh default shell"
sudo chsh -s /bin/zsh
echo "Finished making zsh default shell"

# Source zshrc in zprofile
#sudo echo "source ~/.zshrc" >> ~/.zprofile

# Clear the screen
clear
