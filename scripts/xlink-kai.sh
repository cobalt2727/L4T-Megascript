#https://repo.teamxlink.co.uk/

echo "XLink Kai script started!"

sudo curl https://repo.teamxlink.co.uk/debian/KEY.asc --create-dirs -o /usr/share/keyrings/teamxlink.asc
echo 'deb [signed-by=/usr/share/keyrings/teamxlink.asc] https://repo.teamxlink.co.uk/debian/ /' | sudo tee /etc/apt/sources.list.d/teamxlink.list 
sudo apt update && sudo apt install xlinkkai -y || error "Apt Update/Install Failed"

echo "Done! Sending you back to the main menu..."
