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

set -e # Exit on error

# Prerequisites
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/QDEC"

clear
echo "======================================================================"
echo "DECZILLA INSTALLATION SCRIPT"
echo "Copyleft 2025 CommonPolarity. This script is licensed using the GPL."
echo "======================================================================"
echo "Welcome to the setup included for creating your very own DECzilla!"
echo "It is suggested that you use Fedora Server for the best results."
echo "Currently supported operating systems are Arch Linux, Fedora Server, and Ubuntu Server."
read -p "Which OS do you use? [arch, fedora, ubuntu]: " os
os=$(echo "$os" | tr '[:upper:]' '[:lower:]')

# Installation process
if [[ "$os" == "arch" ]]; then
    sudo pacman -Syu --noconfirm && sudo pacman -S xorg-server xfwm4 xinit xfce4-terminal ufw firefox python python-pip --noconfirm
elif [[ "$os" == "fedora" ]]; then
    sudo dnf update && sudo dnf install xorg-x11-server-Xorg xorg-x11-xinit xfwm4 xfce4-terminal ufw firefox python3.13 -y
    python3.13 -m ensurepip --user
elif [[ "$os" == "ubuntu" ]]; then
    sudo apt update && sudo apt install xorg xfwm4 xinit xfce4-terminal ufw firefox python3.13 python3-pip -y
else
    echo "Unsupported OS. Setup is now exiting."
    exit 1
fi
echo "All requirements successfully installed!"
echo "Press any key to continue installation."
read -s -n 1

# Optional software (Thunar)
clear
echo "======================================================================"
echo "THUNAR INSTALLATION (OPTIONAL)"
echo "======================================================================"
read -p "Would you like to install Thunar additionally for easier file management in 'backend' mode? [y/n]: " opt
opt="${opt,,}" # convert to lowercase

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
    echo "Thunar not installed."
fi
echo "Press any key to continue installation."
read -s -n 1

# Required (but installation optional) software (Git)
clear
echo "======================================================================"
echo "GIT INSTALLATION (SEMI-OPTIONAL)"
echo "======================================================================"
echo "Would you like to install Git from the installer if you don't have it already?"
read -p "This is a required piece of software for the installer to work properly, so please choose Y if you haven't installed [y/n]: " git

git="${git,,}" # convert to lowercase

if [[ "$git" == "y" ]]; then
    if [[ "$os" == "arch" ]]; then
        sudo pacman -S git --noconfirm
    elif [[ "$os" == "fedora" ]]; then
        sudo dnf install git-all -y
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt install git -y
    fi
    echo "Git successfully installed."
else
    echo "Git not installed."
fi
echo "Press any key to continue installation."
read -s -n 1


# QDEC Installation
clear
echo "======================================================================"
echo "QDEC INSTALLATION"
echo "======================================================================"
echo "We will now begin the QDEC installation process."
echo "Press any key to continue installation."
read -s -n 1

cd ~
git clone https://github.com/ApatheticDELL/QDEC.git
cd QDEC

sudo cp "$SCRIPT_DIR/requirements.txt" requirements.txt

python3.13 -m pip install --upgrade pip
python3.13 -m pip install -r requirements.txt
echo "QDEC installation complete!"
echo "Press any key to continue installation."
read -s -n 1

# Port Opening
clear
echo "======================================================================"
echo "PORT OPENING"
echo "======================================================================"
echo "Would you like to allow setup to open up the port necessary for running QDEC so that you're able to use the hosted site on other devices?"
echo "This is highly recommended to prevent tedious usage."
read -p "Open port? [y/n]: " port
port="${port,,}"

if [[ "$port" == "y" ]]; then
    sudo ufw enable
    sudo ufw allow 5000
    echo "Port opened successfully!"
elif [[ "$port" == "n" ]]; then
    echo "Port not opened. You will need to open it yourself if you want to use QDEC on other devices."
else
    echo "Port not opened due to incoherent response. You will need to open it yourself if you want to use QDEC on other devices."
fi
echo "Press any key to continue installation."
read -s -n 1

# X Server Configuration
clear
echo "======================================================================"
echo "X SERVER CONFIGURATION"
echo "======================================================================"
echo "We will now begin the installation of the X Server configuration provided."
echo "Press any key to continue installation."
read -s -n 1

sudo cp "$SCRIPT_DIR/.xinitrc" "$HOME/.xinitrc"
echo "X Server configuration installation complete!"
echo "Press any key to continue installation."
read -s -n 1

# ASCII Option
clear
echo "======================================================================"
echo "ASCII ART (OPTIONAL, FOR NOVELTY)"
echo "======================================================================"
echo "If you would like to, you are able to print out ASCII art at login that says 'DECzilla'."
read -p "Would you like to enable this? This will not change anything functionally. [y/n]: " ascii
ascii="${ascii,,}"

if [[ "$ascii" == "y" ]]; then
    echo "echo \" __/\\\\\\\\\\\\_____/\\\\\\\\\\\\\\\________/\\\\\\\\\______________________/\\\\\\_____/\\\\\\___________________        \"" >> "$HOME/.profile"
    echo "echo \" _\/\\\////////\\\__\/\\\///////////______/\\\////////______________________\////\\\____\////\\\___________________       \"" >> "$HOME/.profile"
    echo "echo \"  _\/\\\______\//\\\_\/\\\_______________/\\\/__________________________/\\\____\/\\\_______\/\\\___________________      \"" >> "$HOME/.profile"
    echo "echo \"   _\/\\\_______\/\\\_\/\\\\\\\\\\\______/\\\______________/\\\\\\\\\\\_\///_____\/\\\_______\/\\\_____/\\\\\\\\\____     \"" >> "$HOME/.profile"
    echo "echo \"    _\/\\\_______\/\\\_\/\\\///////______\/\\\_____________\///////\\\/___/\\\____\/\\\_______\/\\\____\////////\\\___    \"" >> "$HOME/.profile"
    echo "echo \"     _\/\\\_______\/\\\_\/\\\_____________\//\\\_________________/\\\/____\/\\\____\/\\\_______\/\\\______/\\\\\\\\\\__   \"" >> "$HOME/.profile"
    echo "echo \"      _\/\\\_______/\\\__\/\\\______________\///\\\_____________/\\\/______\/\\\____\/\\\_______\/\\\_____/\\\/////\\\__  \"" >> "$HOME/.profile"
    echo "echo \"       _\/\\\\\\\\\\\\\/___\/\\\\\\\\\\\\\\\____\////\\\\\\\\\__/\\\\\\\\\\\_\/\\\__/\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\/\\_ \"" >> "$HOME/.profile"
    echo "echo \"        _\////////////_____\///////////////________\/////////__\///////////__\///__\/////////__\/////////___\////////\//__ \"" >> "$HOME/.profile"
    echo "ASCII art added to ~/.profile. It will show up next time you log in!"
else
    echo "ASCII art not enabled."
fi
echo "Press any key to continue installation."
read -s -n 1

# Autostart Option
clear
echo "======================================================================"
echo "AUTOSTART QDEC AT LOGIN"
echo "======================================================================"
echo "If you would like to, you are able to automatically start QDEC at login."
echo "It is highly suggested that you do it, as this makes the process of starting QDEC much simpler."
read -p "Would you like to enable this? [y/n]: " autostart
autostart="${autostart,,}"

if [[ "$autostart" == "y" ]]; then
    echo "cd $HOME/QDEC && python3.13 QDEC.py & startx" >> "$HOME/.profile"
    echo "QDEC autostart added!"
elif [[ "$autostart" == "n" ]]; then
    echo "QDEC autostart not added."
else
    echo "startx" >> "$HOME/.profile"
    echo "Incoherent answer, QDEC autostart automatically added."
    echo "If you do not want this, install nano if not installed, then run:"
    echo "nano ~/.profile"
    echo "and remove the line that says 'cd $HOME/QDEC && python3.13 QDEC.py & startx'."
fi
echo "Press any key to continue installation."
read -s -n 1

# Final message and restart
clear
echo "======================================================================"
echo "INSTALLATION COMPLETE"
echo "======================================================================"
echo "You have finished the installation to make your own DECzilla."
read -p "Would you like to restart this computer for safe measures? [y/n]: " restart
restart="${restart,,}"

if [[ "$restart" == "y" ]]; then
    echo "Restarting..."
    sudo shutdown -r now
elif [[ "$restart" == "n" ]]; then
    echo "Computer will not restart."
else
    echo "Incoherent answer, computer will not restart."
fi

echo "Exiting installation..."
exit 0