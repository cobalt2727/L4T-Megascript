echo "Heroku script started!"

#if the user is on amd64, we should use the following instead - I'll add this later:
#curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

#but ARM users can only use this:

echo "Adding NodeSource repo for nodejs and npm..."
sleep 1
#https://github.com/nodesource/distributions
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs #npm gets installed alongside the NodeSource package
sudo npm install -g npm #make sure NPM is updated, possibly out of date from nodesource install

echo "Installing heroku-cli..."
sleep 1

sudo npm install -g heroku
notify-send "$(heroku --version)" | echo "" && echo "" && heroku --version

#https://devcenter.heroku.com/articles/heroku-cli#getting-started
#do some error handling depending on whether the user's on SSH or not
if [[ $DISPLAY ]]; then
  heroku login | echo "" && echo -e "\e[31mThe L4T Megascript couldn't open your browser, running Heroku's command line login instead:\e[0m" && heroku login -i
else
  echo -e "\e[35mheroku login -i\e[0m"
  heroku login -i
fi

