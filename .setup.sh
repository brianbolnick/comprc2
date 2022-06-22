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
files="zshrc vimrc vim tmux.conf gitconfig"    # list of files/folders to symlink in homedir
export YELLOW='\033[1;33m'
export PURPLE='\033[0;35m'
export GREEN='\033[0;32m'
export NC='\033[0m'

##########

echo -e "${YELLOW}Starting setup script..... ${PURPLE} ====>${NC}"

## oh my zsh
echo -e "${YELLOW}Setting up Oh My Zsh ${PURPLE} ====>${NC}"
mkdir $ZSH_CUSTOM/themes
wget -O $ZSH_CUSTOM/themes/hyperzsh.zsh-theme https://raw.githubusercontent.com/tylerreckart/hyperzsh/master/hyperzsh.zsh-theme

# Change permissions on zsh files
sudo chown -R $(whoami):staff ~/.oh-my-zsh ~/.zsh*

# create dotfiles_old in homedir
echo -e "${YELLOW}Creating $olddir for backup of any existing dotfiles in ~ ${PURPLE} ====>${NC}"
mkdir -p $olddir
echo -e "${YELLOW}Finished creating $olddir for backup of any existing dotfiles in ~ ${PURPLE} ====>${NC}"

# change to the dotfiles directory
echo -e "${YELLOW}Changing to the $dir directory ${PURPLE} ====>${NC}"
cd $dir
echo -e "${YELLOW}Finished changing to the $dir directory ${PURPLE} ====>${NC}"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo -e "${YELLOW}Moving any existing dotfiles from ~ to $olddir ${PURPLE} ====>${NC}"
for file in $files; do
	mv ~/.$file $olddir
	echo -e "${YELLOW}Creating symlink to $file in home directory. ${PURPLE} ====>${NC}"
	ln -s $dir/.$file ~/.$file
done
echo -e "${YELLOW}Finished moving any existing dotfiles from ~ to $olddir ${PURPLE} ====>${NC}"

# Install Plug for managing Vim plugins
#echo -e "${YELLOW}Installing Plug ${PURPLE} ====>${NC}"
#sudo curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#echo -e "${YELLOW}Finished installing Plug ${PURPLE} ====>${NC}"

# Change permissions on autload file
#echo -e "${YELLOW}Changing vim autoload permissions ${PURPLE} ====>${NC}"
#sudo chmod -R 755 ~/.vim/autoload
#echo -e "${YELLOW}Finished changing vim autoload permissions ${PURPLE} ====>${NC}"

# Install the rest of the plugins
echo -e "${YELLOW}Installing All Vim Plugins ${PURPLE} ====>${NC}"
sudo vim +PlugInstall +qall
echo -e "${YELLOW}Finished Installing All Vim Plugins ${PURPLE} ====>${NC}"

# Make fzf history public
echo -e "${YELLOW}Changing fzf history permissions ${PURPLE} ====>${NC}"
sudo chmod -R 755 ~/.local/share/fzf-history
echo -e "${YELLOW}Finished changing fzf history permissions ${PURPLE} ====>${NC}"

# Install NVM
echo -e "${YELLOW}Installing NVM ${PURPLE} ====>${NC}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# install latest version of node
nvm install node
echo -e "${YELLOW}Finished setting up NVM ${PURPLE} ====>${NC}"


# add customizations
echo -e "${YELLOW}Adding some paint..... ${PURPLE} ====>${NC}"
# pure prompt
npm install --g pure-prompt

# powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh && cd ..

# auto suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# configure git
#echo -e "${YELLOW}What email would you like to use for git? ${PURPLE} ====>${NC}"
#read git_email
#git config --global user.email $git_email
#git config --global core.excludesfile ~/.gitignore-global

#SSH stuff
echo -e "${YELLOW}Follow the instructions below for creating a default SSH key ${PURPLE} ====>${NC}"
ssh-keygen -t rsa
echo -e "${YELLOW}Finished with customizations ${PURPLE} ====>${NC}"

# switch to zsh shell
echo -e "${YELLOW}Making zsh default shell ${PURPLE} ====>${NC}"
sudo chsh -s $(which zsh)
echo -e "${YELLOW}Finished making zsh default shell ${PURPLE} ====>${NC}"

# Source zshrc in zprofile
#sudo echo "source ~/.zshrc" >> ~/.zprofile

# Clear the screen
clear
echo -e "${YELLOW}===== ${GREEN}You're up and running!${YELLOW} =====${NC}"
