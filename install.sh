#!/bin/bash

#------------------
#----- CONFIG -----
#------------------

#Utilities

get_install_deb() {
    local APP="$1"
    local URL="$2"

    if dpkg-query -W -f='${Status}' "$APP" 2>/dev/null | grep -q "installed"; then
        echo "$APP is already installed."
    else
        sudo wget -O ~/d.deb "$URL"
        sudo dpkg -i ~/d.deb
        sudo rm ~/d.deb
    fi
}

get_install_apt() {
    local APP="$1"

    if [ "$APP" == false ]; then
        echo "Skipping."
    else
        sudo apt install $APP
    fi
}


update_config_files(){
    local APP="$1"
    if [ -d ~/.config ]; then
        rm -r ~/.config/"${APP}"
    fi
    mkdir -p ~/.config/"${APP}"
    cp -r ./LHA/"${APP}" ~/.config
}

add_desktop_file(){
    local APP="$1"
    sudo cp -r ./LHA/"${APP}".desktop /usr/share/applications
}

#-------------------------
#----- END OF CONFIG -----
#-------------------------

#Start of the script
echo "--------------------------------"
echo "Installing necessary packages..."
echo "--------------------------------"

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install -y wget                           # To install other apps
#sudo apt-get install -y lightdm -f                     #Login Screen
sudo apt-get install -y startx -f                      #Login Screen
sudo apt-get install -y xorg -f                        #

#sudo apt-get install -y i3 -f                          #Window Manager
sudo apt-get install -y jq -f                          #Utility for i3 script
sudo apt-get install -y wmctrl -f                      #Utility for i3 script
sudo apt-get install -y xdotool -f                     #Utility for i3 script

sudo apt-get install -y polybar -f                     #Polybar
sudo apt-get install -y policykit-1-gnome -f           #PolKit
sudo apt-get install -y libnotify-bin -f               #Notifications daemon
sudo apt-get install -y dunst -f                       #Notifications
sudo apt-get install -y gdebi -f                       #Double clic install

sudo apt-get install -y fonts-roboto -f                #Font
sudo apt-get install -y feh -f                         #Background image
sudo apt-get install -y lxappearance -f                #Theme manager

sudo apt-get install -y rofi -f                        #Apps menu
sudo apt-get install -y alacritty -f                   #Terminal
sudo apt-get install -y nemo -f                        #Files
sudo apt-get install -y flameshot -f                   #Screenshot taker
sudo apt-get install -y htop -f                        #Check resources stats   

sudo apt-get install -y xbacklight -f                  #Brightess
#sudo apt-get install -y pavucontrol -f                 #Audio GUI
#sudo apt-get install -y blueman -f                     #Bluetooth GUI
#sudo apt-get install -y xfce4-power-manager -f         #Power manager for laptops
sudo apt-get install -y network-manager                #Network manager
sudo apt-get install -y printer-driver-all -y -f       #Printer Utilities
sudo apt-get install -y numlockx -f                    #Used to unlock numpad on start
sudo apt-get install -y qalc -f                        #CLI calculator
sudo apt-get install -y tigervnc-viewer -f             # VNC

sudo apt-get install -y firefox-esr -f                 #Firefox browser
#sudo apt-get install -y libreoffice -f                 #Paquete office

sudo apt-get install -y cmake -f                       #Utilities
sudo apt-get install -y neovim -f                      # Console text editor


echo "-------------------------------"
echo "Installing dependencies.."
echo "-------------------------------"

sudo apt-get --fix-broken install                   #Install dependecies that were not installed

echo "-------------------------------"
echo " Remove unnecesary.."
echo "-------------------------------"

sudo apt remove kded5
sudo apt autoremove

echo "-------------------------------"
echo "Installing optional packages..."
echo "-------------------------------"

echo "-------------------------------"
echo "Installing dependencies.."
echo "-------------------------------"
sudo apt-get --fix-broken install

if [ ! -d ~/.config ]; then
    mkdir -p ~/.config/"${APP}"
fi
sudo chown -R $USER:$USER ~/.config

echo "-------------------------------"
echo "        DE Config files        "
echo "-------------------------------"

update_config_files "dunst"          #Notifications
update_config_files "rofi"           #Apps menu
update_config_files "alacritty"      #Terminal
update_config_files "polybar"        #Bar

#Openbox
sudo cp openbox/autostart /etc/xg/openbox/autostart
sudo cp openbox/rc.xml /etc/xg/openbox/rc.xml
sudo cp openbox/menu.xml /etc/xg/openbox/menu.xml
sudo cp openbox/themerc usr/share/themes/Clearlooks-Olive/openbox-3/themerc

echo "-------------------------------"
echo " .sh files add exec permission "
echo "-------------------------------"

add_exec_permission_to_sh() {
    local directory="$1"

    # Check if directory argument is provided
    if [ -z "$directory" ]; then
        echo "Usage: add_exec_permission_to_sh <directory>"
        return 1
    fi

    # Check if directory exists
    if [ ! -d "$directory" ]; then
        echo "Directory '$directory' not found."
        return 1
    fi

    # Add executable permission to .sh files in the directory recursively
    find "$directory" -type f -name "*.sh" -exec chmod +x {} \;

    echo "Executable permission added to .sh files in '$directory'."
}

add_exec_permission_to_sh ".config/rofi"


echo "-------------------------------"
echo "         Add .desktop          "
echo "-------------------------------"

# add_desktop_file "RofiWifi"

echo "-------------------------------"
echo " NoDisplay unnecesary .desktop "
echo "-------------------------------"

input_file="LHA/NoDisplay.txt" #.desktop files to not display on rofi menu

add_NoDisplay() {
    local desktop_file="$1"

    if grep -q "^NoDisplay=false" "$desktop_file"; then
        sed -i 's/^NoDisplay=false/NoDisplay=true/' "$desktop_file"
        echo "Changed NoDisplay from false to true in $desktop_file"
    elif ! grep -q "^NoDisplay=true" "$desktop_file"; then
        echo "NoDisplay=true" >> "$desktop_file"
        echo "Added NoDisplay=true to $desktop_file"
    else
        echo "NoDisplay=true already exists in $desktop_file"
    fi
}

if [ ! -f "$input_file" ]; then
    echo "Input file $input_file not found"
    exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
    desktop_file="/usr/share/applications/$line"
    if [ -f "$desktop_file" ]; then
        add_NoDisplay "$desktop_file"
    else
        echo "$desktop_file not found"
    fi
done < "$input_file"

echo "-------------------------------"
echo "       Finishing touches       "
echo "-------------------------------"

systemctl enable NetworkManager.service

cp .bash-profile ~/.bash-profile

sudo mkdir -p /etc/systemd/system/getty@tt1.service.d
cp .override.conf /etc/systemd/system/getty@tt1.service.d/override.conf
sudo systemctl daemon-reexec

sudo cp grub /etc/default/grub
sudo update-grub

#sudo rm -r LHA

