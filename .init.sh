#!/bin/bash
############################
# .make.sh
# This script will install all dependencies, 
# move the existing configuration files into a /old_comprc directory, 
# and symlink the configuration files into the home directory.
############################
export PURPLE='\033[0;35m'
export NC='\033[0m'

echo -e "${PURPLE}Installing OS Dependencies${NC}"
if [[ $(uname -m) == 'arm64' ]]; then
	echo -e "${PURPLE}Installing rosetta for apple M1"
	/usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

# Command line tools
xcode-select --install

# Homebrew and tools
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

brew bundle
brew cleanup
echo -e "${PURPLE}Finished Installing OS Dependencies${NC}"

# oh my zsh
echo -e "${PURPLE}Installing Oh My Zsh${NC}"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo -e "${PURPLE}Finished Installing Oh My Zsh${NC}"

