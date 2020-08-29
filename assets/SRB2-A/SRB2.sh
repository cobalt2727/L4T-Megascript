read RES_X RES_Y <<<$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3, $4}') && /usr/share/SRB2/build/bin/lsdlsrb2 use_joystick 1 -width $RES_X -height $RES_Y
