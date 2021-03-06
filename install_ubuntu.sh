#!/bin/bash

#Installation file for CCI-Kiosk
#By David Rhoads
#April 2020

#Sample installation file, your Kiosk user must be named kiosk for this to work
#Special thanks to Oli Warner https://thepcspy.com, Alan D Moore http://alandmoore.com, and NovaSpirit Tech https://www.novaspirit.com/

#Pull changes from GitHub
echo "Installing CCI Kiosk"
git pull https://github.com/kd2flz/cci-kiosk
#Update the server
sudo apt update

#Upgrade the server
sudo apt upgrade -y

#install x server, openbox display manager, chromium browser (open source version of Chrome), and pulse audio, for sound
#--no-install-recommends prevents package manager from installing unnecessary packages wanted by the target packages
sudo apt install -y --no-install-recommends xorg pulseaudio 
sudo apt install -y --no-install-recommends openbox 
sudo apt install -y chromium-browser 
sudo apt install -y systemd-timesyncd
#Install Cockpit for remote management - note, if you are using a non-ubuntu based system, like Debian, you will have to change this command
sudo apt install -y cockpit 

#Install alsa for sound
sudo apt install -y alsa alsa-utils

#Uncomment below to install Citrix Workspace App and Remmina for remote desktop connections
#!Please! Make sure you replace this link with the link to the latest Citrix Workspace App .deb download
sudo apt install -y remmina 

#Install GDM (gnome display manager)
sudo apt install -y gdm3

#Install Plymouth for Boot Splash
sudo apt install -y plymouth plymouth-themes

#Add user "Kiosk"
sudo adduser kiosk 

#Adds Kiosk user to audio group
sudo usermod -a -G audio kiosk

#Copy configuration scripts to correct directories
#copy autostart file to /etc/xdg/openbox
sudo cp autostart /etc/xdg/openbox/
sudo chmod +x /etc/xdg/openbox/autostart

#Set up autologin (works with GDM3)
sudo cp custom.conf /etc/gdm3/

#Setup in-house time sync for using local NTP Servers
#Comment out below if you wish to use the default NTP servers
#Copy timesyncd.conf to /etc/systemd for in-house time sync
sudo cp timesyncd.conf /etc/systemd/timesyncd.conf
#Setup Time Sync
sudo timedatectl set-ntp false
sudo timedatectl set-ntp on

#Allow network to be configured by network manager
sudo chmod +x network_config.sh
sudo ./network_config.sh

#Copy openbox configuration to kiosk home directory
mkdir /home/kiosk/.config/openbox
sudo cp rc.xml /home/kiosk/.config/openbox

#Change grub options
#Use this option with caution IT MAY BREAK YOUR BOOTLOADER
#Uncomment below to disable text on screen at boot
sudo cp grub /etc/default
sudo update-grub