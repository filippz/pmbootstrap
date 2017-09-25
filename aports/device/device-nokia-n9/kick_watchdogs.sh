#!/bin/sh

while :
do
  echo X > /dev/watchdog0
  echo X > /dev/watchdog1
  sleep 10s
done
