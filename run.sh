#!/bin/sh
echo $VPN_PASS | openconnect  $VPN_HOST -u $VPN_USER --authgroup $VPN_GROUP --script-tun --background --script "ocproxy  -L 2222:$SSH_HOST:$SSH_PORT"
ssh -4 -i /keys/id_rsa -o "StrictHostKeyChecking=no" -v -p 2222 -L *:$LOCAL_PORT:$FORWARD_HOST:$FORWARD_PORT -N $SSH_USER@localhost
