/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(homebrew/bin/brew shellenv)"

brew update
brew upgrade

# Install packages
brew install git
brew install zsh
brew install zsh-completions
brew install tmux

# Wait a bit before moving on...
sleep 1

# ...and then.
echo "Success! Basic brew packages are installed."
