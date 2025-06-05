Work in progress...

## **What is LHA DE**

This is just a desktop environment I made for myself to install on any debian minimal installation. It uses i3 as a WM.

## **Installation**

Run the following commands after installing a minimal debian installation. BEWARE: Running this on an already running OS will probably break some functionality.

```
#Get SUDO and GIT
su -
apt-get install sudo
/sbin/adduser $USERNAME sudo
apt install git

#Install the DE
su $USERNAME
cd ~/ #Or cd to /home/$USERNAME
sudo git clone https://github.com/angelellij/LHA
sudo nano ./LHA/install.sh #If you want to toggle config
sudo chmod +x ./LHA/install.sh
./LHA/install.sh #No sudo!!!
```

## **Post-install**

Autologin

```
#Run on terminal
sudo nano /etc/lightdm/lightdm.conf

#Change lines below [Seat:*]
autologin-user=<username>
autologin-user-timeout=0

#Restart lightdm
sudo systemctl restart lightdm
```

Skip Grub

```
#Run on terminal
sudo nano /etc/default/grub

#Change lines below [Seat:*]
GRUB_TIMEOUT=0

#Update grub
sudo update-gurb
```