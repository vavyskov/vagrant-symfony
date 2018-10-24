#!/bin/bash
set -eu

## Detect first parameter
if [ $1 = "up" ]; then
    ## Enable port forwarding on start up
    sudo iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080
    sudo iptables -t nat -I OUTPUT -p tcp -o lo --dport 443 -j REDIRECT --to-ports 4443
elif [ $1 = "down" ]; then
    ## Disable port forwarding when shutting down
    sudo iptables -t nat -D OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080
    sudo iptables -t nat -D OUTPUT -p tcp -o lo --dport 443 -j REDIRECT --to-ports 4443
fi
