echo "Sublime Text script started!"

sudo apt install wget apt-transport-https software-properties-common -y

echo "Credits:"
echo "https://www.sublimetext.com/docs/linux_repositories.html for setup guide"

if grep -q bionic /etc/os-release; then

  echo "https://github.com/lulle2007200/sublime_on_arm64_bionic for patching Sublime to use a low enough glibc version to run on Ubuntu 18.04"
  sleep 7
  #TIL you can do this with literally anything prompting you for yes/no commands
  yes | sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/lulle2007200/sublime_on_arm64_bionic/master/install_sublime.sh)"

else

  sleep 5
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt-get update
  sudo apt-get install sublime-text -y
  echo "Done!"

fi

echo "Sending you back to the main menu..."
