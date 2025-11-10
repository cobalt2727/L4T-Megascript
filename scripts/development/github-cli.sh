#!/bin/bash

if command -v apt >/dev/null; then
  type -p curl >/dev/null || sudo apt install curl -y
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
    sudo apt update &&
    sudo apt install gh -y || error "Failed to install Github CLI!"
elif command -v dnf >/dev/null; then
  sudo dnf install -y --refresh 'dnf-command(config-manager)' || error "Failed to install dependencies!"
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install -y --refresh gh || error "Failed to install Github CLI!"
else
  error "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi

echo "Done!"
sleep 1
