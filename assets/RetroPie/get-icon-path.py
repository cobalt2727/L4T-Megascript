#!/usr/bin/env python3
 
# ==========================================================================================
# This script is for looking up an icon file path based on the icon name from a *.desktop file.
# Parts of it are based on snippets provided by Stefano Palazzo and kiri on askubuntu.com
#   https://askubuntu.com/questions/52430/how-can-i-find-the-location-of-an-icon-of-a-launcher-in-use
# ==========================================================================================
# The original version(s) simply prompted the user for the icon name.
# However, I have modified this version in the following ways:
#   1. Added ability to pass specific size as arg (e.g. --size=22 or --size=48, etc)
#   2. Added ability to pass icon names as arg (any other arg besides --size)
#       Note: if --size is used with multiple icon names, then it is assummed
#             that all of the icons in the search will be for the same size
#   3. Like kiri's version, I removed the hard-coded size of 48x48 and default to all sizes
#   4. Unlike kiri's version, you can optionally still search for a specific size (using #1)
#   5. Performance improvements from kiri's version (he was checking every even number from
#       0 to 500 -- so 250 iterations. I base mine off the values that actually existing under
#       /etc/share/icons/hicolor - of which there were 17. So his is more flexible but
#       mine should be quicker and more forgiving in terms of HDD wear and tear)
# ==========================================================================================
 
import gi
import sys
import array as arr 
 
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
 
def resolveIconPath( iconName, iconSize = -1 ):
    "This takes a freedesktop.org icon name and prints the GTK 3.0 resolved file location."
 
    iconTheme = Gtk.IconTheme.get_default()
    
    # if looking up a specific size
    if iconSize >= 16:
        msgTemplate = "iconname: \"" + iconName + "\" (size: " + str(iconSize) + "): "
        
        iconFile = iconTheme.lookup_icon(iconName, iconSize, 0)
        if iconFile:
            print(msgTemplate + iconFile.get_filename() + "\n")
        else:
            print("W:" + msgTemplate + " No matching path(s) found.\n")
    else:
        # otherwise, look up *all* sizes that can be found
        sep="===================================================================="
        msgTemplate = sep + "\niconname: \"" + iconName + "\":\n" + sep
        
        foundIconsList = list()
        for resolution in [16, 20, 22, 24, 28, 32, 36, 48, 64, 72, 96, 128, 192, 256, 480, 512, 1024]:
            iconFile = iconTheme.lookup_icon(iconName, resolution, 0)
            if iconFile:
                filePath=str(iconFile.get_filename())
                if not (filePath in foundIconsList):
                    foundIconsList.append(iconFile.get_filename())
 
        if foundIconsList:
            print(msgTemplate + "\n"+ "\n".join(foundIconsList)+ "\n")
        else:
            print("W: iconname: \"" + iconName + "\":  No matching path(s) found.\n")
        return
 
 
# get the total number of args passed (excluding first arg which is the script name)
argumentsLen = len(sys.argv) - 1
 
# define a list for storing all passed icon names
iconNamesList = []
 
# loop through passed args, if we have any and handle appropriately
showHelp=False
size=-1
if argumentsLen > 0:
    for i in range(1, len(sys.argv)):
        arg=str(sys.argv[i])
        #print(i, "arg: " + arg)
        if arg.startswith('--size=') or arg.startswith('-s=') or arg.startswith('-S='):
            tmpSize=(arg.split("=",2))[1]
            if len(tmpSize) > 0 and tmpSize.isnumeric():
                size=int(tmpSize)
            else:
                print("Invalid size '" + tmpSize + "'; Expected --size=xx where xx is a positive integer.")
        elif arg == '--help' or arg == '-h':
            print(str(sys.argv[0]) + " [OPTIONS] [ICON_NAME]\n")
            print("Takes a freedesktop.org/GNOME icon name, as commonly appears in a *.desktop file,")
            print("and performs a lookup to determine matching filesystem path(s). By default, this")
            print("path resolution is determined for all available icon sizes. However, a specific")
            print("size can be used by providing one of the options below.\n")
            print("OPTIONS:")
            print("  -s=n, --size=n   Restricts path resolution to icons matching a specific size.")
            print("                   The value n must be a positive integer correspending to icon size.")
            print("                   When using this option with multiple passed icon names, the size")
            print("                   restrictions are applied to *all* of the resolved icons. Querying")
            print("                   different sizes for different icons is only possible via the use of")
            print("                   multiple calls or by parsing the default output.\n")
            print("  -h, --help       Display this help page and exit.\n")
            exit()
        else:
            iconNamesList.append(arg)
 
# if no icon names were passed on command line, then prompt user
if len(iconNamesList) == 0:
    iconNamesList.append(input("Icon name (case sensitive): "))
 
#print("size: " + str(size))
#print("iconNamesList: ")
if len(iconNamesList) > 0:
    for iconName in iconNamesList:
        if size < 16:
            # find all sizes (on my system, 16x16 was the smallest size icons under hicolor)
            resolveIconPath(iconName)
        else:
            # use custom size
            resolveIconPath(iconName, size)