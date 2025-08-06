#!/bin/bash

#  Installer for
# __/\\\\\\\\\\\\_____/\\\\\\\\\\\\\\\________/\\\\\\\\\______________________/\\\\\\_____/\\\\\\___________________        
# _\/\\\////////\\\__\/\\\///////////______/\\\////////______________________\////\\\____\////\\\___________________       
#  _\/\\\______\//\\\_\/\\\_______________/\\\/__________________________/\\\____\/\\\_______\/\\\___________________      
#   _\/\\\_______\/\\\_\/\\\\\\\\\\\______/\\\______________/\\\\\\\\\\\_\///_____\/\\\_______\/\\\_____/\\\\\\\\\____     
#    _\/\\\_______\/\\\_\/\\\///////______\/\\\_____________\///////\\\/___/\\\____\/\\\_______\/\\\____\////////\\\___    
#     _\/\\\_______\/\\\_\/\\\_____________\//\\\_________________/\\\/____\/\\\____\/\\\_______\/\\\______/\\\\\\\\\\__   
#      _\/\\\_______/\\\__\/\\\______________\///\\\_____________/\\\/______\/\\\____\/\\\_______\/\\\_____/\\\/////\\\__  
#       _\/\\\\\\\\\\\\/___\/\\\\\\\\\\\\\\\____\////\\\\\\\\\__/\\\\\\\\\\\_\/\\\__/\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\/\\_ 
#        _\////////////_____\///////////////________\/////////__\///////////__\///__\/////////__\/////////___\////////\//__
# Copyleft 2025 CommonPolarity. This script is licensed using the GPL.

# Prerequisites
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)" # Sets directory of script
TARGET_DIR="~/QDEC" # For QDEC

echo "Welcome to the setup included for creating your very own DECzilla!"
echo "It is suggested that you use Fedora Server for the best results."
echo "Currently supported operating systems are Arch Linux, Fedora Server, and Ubuntu Server."
read -p "Which OS do you use? [arch, fedora, ubuntu]: " os
os=$(echo "$os" | tr '[:upper:]' '[:lower:]')

# Installation process (required)
if [[ "$os" == "arch" ]]; then
    sudo pacman -Syu --noconfirm && sudo pacman -S xorg-server xfwm4 xinit xfce4-terminal git firefox python python-pip --noconfirm
elif [[ "$os" == "fedora" ]]; then
    sudo dnf update && sudo dnf install xorg-x11-server-Xorg xorg-x11-xinit xfwm4 xfce4-terminal git-all firefox python3.13 -y
    python3.13 -m ensurepip --user
elif [[ "$os" == "ubuntu" ]]; then
    sudo apt update && sudo apt install xorg xfwm4 xinit xfce4-terminal git firefox python3.13 -y
else
    echo "Unsupported OS. Setup is now exiting."
    exit 1
fi

# Optional software (Thunar)
echo "All requirements successfully installed!"
read -p "Would you like to install Thunar additionally for easier file management in 'backend' mode? [y/n]: " opt

if [[ "$opt" == "y" ]]; then
    if [[ "$os" == "arch" ]]; then
        sudo pacman -S thunar --noconfirm
    elif [[ "$os" == "fedora" ]]; then
        sudo dnf install thunar -y
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt install thunar -y
    fi
    echo "Thunar also installed."
else
    echo "Nothing else installed."
fi

# QDEC Installation
clear
echo "We will now begin the QDEC installation process."
echo "QDEC allows for you to send (and if wanted) receive alerts."
echo "Press any key to continue installation."
read -s -n 1

# Clone the QDEC repository
cd ~
git clone https://github.com/ApatheticDELL/QDEC.git
cd QDEC

# Replace the default requirements file with our custom one
sudo cp "$SCRIPT_DIR/requirements.txt" requirements.txt

# Install Python dependencies
python3 -m pip install -r requirements.txt