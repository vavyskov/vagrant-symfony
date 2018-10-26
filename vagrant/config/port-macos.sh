#!/bin/bash
set -eu

## Detect first parameter
if [ $1 = "up" ]; then
    ## Enable port forwarding on start up
    ##rdr pass inet proto tcp from any to any port 80 -> 127.0.0.1 port 8080
    ##rdr pass inet proto tcp from any to any port 443 -> 127.0.0.1 port 4443
    echo '
        rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080
        rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 443 -> 127.0.0.1 port 4443
    ' | sudo pfctl -ef - > /dev/null 2>&1
elif [ $1 = "down" ]; then
    ## Disable port forwarding when shutting down
    #sudo pfctl -F nat -f /etc/pf.conf
    sudo pfctl -df /etc/pf.conf > /dev/null 2>&1
fi
