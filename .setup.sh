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
export PURPLE='\033[0;35m'
export NC='\033[0m'

##########

echo -e "${PURPLE}Starting.....${NC}"
#if [[ $(uname -m) == 'arm64' ]]; then
	#echo -e "${PURPLE}Installing rosetta for apple M1${NC}"
	#/usr/sbin/softwareupdate --install-rosetta --agree-to-license
#fi

## Command line tools
#xcode-select --install

## Homebrew and tools
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
#brew install coreutils
#ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

#brew bundle
#brew cleanup
#echo -e "${PURPLE}Finished Installing OS Dependencies${NC}"

## oh my zsh
#echo -e "${PURPLE}Installing Oh My Zsh${NC}"
#sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#echo -e "${PURPLE}Finished Installing Oh My Zsh${NC}"

# Change permissions on zsh files
sudo chown -R $(whoami):staff ~/.oh-my-zsh ~/.zsh*

# create dotfiles_old in homedir
echo -e "${PURPLE}Creating $olddir for backup of any existing dotfiles in ~${NC}"
mkdir -p $olddir
echo -e "${PURPLE}Finished creating $olddir for backup of any existing dotfiles in ~${NC}"

# change to the dotfiles directory
echo -e "${PURPLE}Changing to the $dir directory${NC}"
cd $dir
echo -e "${PURPLE}Finished changing to the $dir directory${NC}"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo -e "${PURPLE}Moving any existing dotfiles from ~ to $olddir${NC}"
for file in $files; do
	mv ~/.$file $olddir
	echo -e "${PURPLE}Creating symlink to $file in home directory.${NC}"
	ln -s $dir/.$file ~/.$file
done
echo -e "${PURPLE}Finished moving any existing dotfiles from ~ to $olddir${NC}"

# Install Plug for managing Vim plugins
#echo -e "${PURPLE}Installing Plug${NC}"
#sudo curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#echo -e "${PURPLE}Finished installing Plug${NC}"

# Change permissions on autload file
#echo -e "${PURPLE}Changing vim autoload permissions${NC}"
#sudo chmod -R 755 ~/.vim/autoload
#echo -e "${PURPLE}Finished changing vim autoload permissions${NC}"

# Install the rest of the plugins
echo -e "${PURPLE}Installing All Vim Plugins${NC}"
sudo vim +PlugInstall +qall
echo -e "${PURPLE}Finished Installing All Vim Plugins${NC}"

 #Change permissions on autload file...already do this up above
 #sudo chmod -R 755 ~/.vim/autoload

# Make fzf history public
echo -e "${PURPLE}Changing fzf history permissions${NC}"
sudo chmod -R 755 ~/.local/share/fzf-history
echo -e "${PURPLE}Finished changing fzf history permissions${NC}"

# Install NVM
echo -e "${PURPLE}Installing NVM${NC}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

echo -e "${PURPLE}Finished setting up NVM${NC}"


# add customizations
echo -e "${PURPLE}Adding some paint.....${NC}"
# pure prompt
npm install --g pure-prompt

# auto suggestions
#git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#syntax highlighting
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
#echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
#source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# configure git
echo -e "${PURPLE}What email would you like to use for git?${NC}"
read git_email
git config --global user.email $git_email
git config --global core.excludesfile ~/.gitignore-global

#SSH stuff
echo -e "${PURPLE}Follow the instructions below for creating a default SSH key${NC}"
ssh-keygen -t rsa
echo -e "${PURPLE}Finished with customizations${NC}"

# switch to zsh shell
echo -e "${PURPLE}Making zsh default shell${NC}"
sudo chsh -s $(which zsh)
echo -e "${PURPLE}Finished making zsh default shell${NC}"

# Source zshrc in zprofile
#sudo echo "source ~/.zshrc" >> ~/.zprofile

# Clear the screen
clear
