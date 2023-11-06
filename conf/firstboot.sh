#!/bin/sh

# Add prepper user
useradd -s /usr/bin/bash -m -U -G wheel,network -k /etc/skel prepper
echo 'prepper:prepper' | chpasswd --crypt-method SHA512

# setup pacman
pacman-key --init
pacman-key --populate
