sudo apt install telnet -y
clear
echo "The script will now run the command \e[32mtelnet towel.blinkenlights.nl\e[0m"
echo "For more info on what this is and how"
echo "it works, Ctrl+click the following link:"
##echo "http://www.blinkenlights.nl/thereg/"
echo "http://www.asciimation.co.nz/"
echo "This message will close in 30 seconds,"
echo "and the movie will start. Press Ctrl + C"
echo "or click the X on the terminal window to cancel"
echo "at any time. Enjoy!"
sleep 30
telnet towel.blinkenlights.nl
