#!/bin/sh

source /connect.sh &
sleep 2
ssh -4 -i /id_rsa -o "StrictHostKeyChecking=no" -v -p $SSH_PORT -L *:$LOCAL_PORT:$FORWARD_HOST:$FORWARD_PORT -N $SSH_USER@$SSH_HOST 
