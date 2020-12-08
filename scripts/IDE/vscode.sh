clear
echo "Installing the aarch64 build of Visual Studio Code directly from Microsoft..."
sleep 5

##i'd be surprised if these weren't already installed, but...
sudo apt install wget gpg -y

##Thankfully Microsoft has a link that always downloads whatever the latest version is.
##the -O parameter lets me choose the filename myself to make the installation lines easier
wget -O vscode-latest.deb https://aka.ms/linux-arm64-deb
sudo dpkg -i vscode-latest.deb
sudo apt --fix-broken install
echo "Done! You can now launch VS Code from your app list or by typing 'code' into a terminal."
sleep 1

echo "Removing the .deb file..."
rm vscode-latest.deb

echo "Done! Going back to the main menu..."
