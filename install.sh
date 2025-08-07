#!/bin/bash

#  Installation script for
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
echo "QDEC installation complete!"
echo "Press any key to continue installation."
read -s -n 1

# Open port for server use on other devices
clear
echo "Would you like to allow setup to open up the port necessary for running QDEC so that you're able to use the hosted site on other devices?"
echo "This is highly recommended to prevent tedious usage."
read -p "Open port? [y/n]: " port

# Port logic
if [[ "$port" = "y" ]]; then
    sudo ufw allow 8080
    echo "Port opened successfully!"
elif [[ "$port" = "n" ]]; then
    echo "Port not opened. You will need to open it yourself if you want to use QDEC on other devices."
else
    echo "Port not opened due to incoherent response. You will need to open it yourself if you want to use QDEC on other devices."
fi
echo "Press any key to continue installation."
read -s -n 1


# X Server Configuration Installation
clear
echo "We will now begin the installation of the X Server configuration provided."
echo "QDEC allows for you to send (and if wanted) receive alerts."
echo "Press any key to continue installation."
read -s -n 1

# Change directory to `~` and replace script
cd ~
sudo cp "$SCRIPT_DIR/.xinitrc" .xinitrc
echo "X Server configuration installation complete!"
echo "Press any key to continue installation."

# Line addition to automatically start (Optional, recommended)
clear
echo "If you would like to, you are able to automatically start QDEC at login."
echo "It is highly suggested that you do it, as this makes the process of starting QDEC much simpler."
read -p "Would you like to enable this? [y/n]: " autostart

# Autostart logic
if [[ "$autostart" = "y" ]]; then
    cd ~
    echo "xstart" >> .profile
    echo "QDEC autostart added!"
    echo "Press any key to continue installation."
    read -s -n 1
elif [[ "$autostart" = "n" ]]; then
    echo "QDEC autostart not added."
    echo "Press any key to continue installation."
    read -s -n 1
else
    cd ~
    echo "xstart" >> .profile
    echo "Incoherent answer, QDEC autostart automatically added."
    echo "If you do not want this, install nano if not installed, cd into ~ and run the following command post-setup:"
    echo "sudo nano .profile"
    echo "and remove the line that says 'xstart' before saving."
    echo "Press any key to continue installation."
    read -s -n 1
fi

# Installation finished
clear
echo "You have finished the installation to make your own DECzilla."
read -p "Would you like to restart this computer for safe measures? [y/n]: " restart

# Restart logic
if [[ "$autostart" = "y" ]]; then
    echo "Restarting..."
    sudo shutdown -r now
elif [[ "$autostart" = "n" ]]; then
    echo "Computer will not restart."
else
    cd ~
    echo "xstart" >> .profile
    echo "Incoherent answer, computer will not restart."
fi
echo "Exiting installation..."
exit 1