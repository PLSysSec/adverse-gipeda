#!/bin/bash

# The approximate percentage-idle of the machine (all CPUs averaged).
# Gives an integer 0-100.
idlepct() {
  sleep 0.1
  pre_busy=`head -n 1 /proc/stat | awk '{print $2+$4}'`
  pre_idle=`head -n 1 /proc/stat | awk '{print $5}'`
  sleep 1
  post_busy=`head -n 1 /proc/stat | awk '{print $2+$4}'`
  post_idle=`head -n 1 /proc/stat | awk '{print $5}'`
  busy=$(($post_busy-$pre_busy))  # how much busy in the 1 second
  idle=$(($post_idle-$pre_idle))  # how much idle in the 1 second
  echo $(( $idle*100 / ($busy+$idle) ))
}
