#https://repo.teamxlink.co.uk/

echo "XLink Kai script started!"

sudo apt install ca-certificates curl gnupg -y || errpr "Couldn't install dependencies!"
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://dist.teamxlink.co.uk/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/teamxlink.gpg
sudo chmod a+r /etc/apt/keyrings/teamxlink.gpg
echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/teamxlink.gpg] https://dist.teamxlink.co.uk/linux/debian/static/deb/release/ /" | sudo tee /etc/apt/sources.list.d/teamxlink.list > /dev/null
sudo apt update && sudo apt install xlinkkai -y || error "Apt Update/Install Failed"

echo "Done! Sending you back to the main menu..."
