#!/bin/sh


echo "Starting openconect"
echo $VPN_PASS | openconnect  $VPN_HOST -u $VPN_USER --authgroup $VPN_GROUP 
