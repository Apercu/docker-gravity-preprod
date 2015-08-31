#!/bin/sh
while ! curl localhost:27017
do
  echo "$(date) - still trying"
  sleep 1
done
/usr/bin/node /home/gravity/gravity-api/src
