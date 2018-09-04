#/bin/bash
echo -n $'\e[35m'
echo $'______      _                                       '
echo $'|  _  \    | |                                      '
echo $'| | | |__ _| |_ __ _ _ __   ___  _ __   ____   ___  '
echo $'| | | / _  | __/ _` |  _ \ / _ \|  __| |  _ \ / _ \ '
echo $'| |/ / (_| | || (_| | |_) | (_) | | _  | | | | (_) |'
echo $'|___/ \__,_|\__\__,_| .__/ \___/|_|(_) |_| |_|\___/ '
echo $'                    | |                             '
echo $'                    |_|                             '
echo ""
echo -n $'\E[39m'

##Symlink Dotfiles
dir=~/.dotfiles/files
read -p "Symlink dotfiles ? Y/n " option
echo
case "$option" in
    y|Y) echo "Yes"; dotfiles=".moc .vim .bashrc .gitconfig .vimrc .Xdefaults .zshrc .Xresources";
        for dotfile in $dotfiles; do
            printf "Installing %s..." $dotfile
            echo
            ln -svf /home/$USER/.dotfiles/files/$dotfile ~/$dotfile 2>/dev/null
        done;;
    n|N ) echo "No";;
esac
echo

##Add Public key
read -p "Add public key ? Y/n " option
echo
case "$option" in
    y|Y) echo "Yes";
        mkdir -p /home/$USER/.ssh/;
        touch /home/$USER/.ssh/authorized_keys;
        wget -qO - $2 > '/home/$USER/.ssh/authorized_keys';;
    n|N ) echo "No";;
esac
echo


# \n
# DEBIAN CORE 
##Set debian flavor
#read -p "$(echo -e 'What Debian Flavor do you want ?\n1: Stretch (Stable)\n2: Buster (Testing)\n3: Sid (Unstable)\n4: Roll backup\n\b')" option
#echo  
#case "$option" in
#    1 ) echo "Stretch (Stable)";
#        cd /etc/apt/;
#        sudo cp sources.list sources.list.bak;
#        echo -e "# Debian Stretch (Stable)\ndeb [arch=amd64] http://ftp.no.debian.org/debian/ stretch main contrib non-free\ndeb-src [arch=amd64] http://ftp.no.debian.org/debian/ stretch main contrib non-free\n\ndeb [arch=amd64] http://ftp.no.debian.org/debian/ stretch-updates main contrib non-free\ndeb-src [arch=amd64] http://ftp.no.debian.org/debian/ stretch-updates main contrib non-free\n\ndeb [arch=amd64] http://security.debian.org/ stretch/updates main contrib non-free\ndeb-src [arch=amd64] http://security.debian.org/ stretch/updates main contrib non-free\n" | sudo tee sources.list;;
    
#    2 ) echo "Buster (Testing)";
#        cd /etc/apt/;
#        sudo cp sources.list sources.list.bak;
#        echo -e "###### Debian Buster (Testing)\ndeb [arch=amd64] http://ftp.no.debian.org/debian/ buster main contrib non-free\ndeb-src [arch=amd64] http://ftp.no.debian.org/debian/ buster main contrib non-free\n\ndeb [arch=amd64] http://ftp.no.debian.org/debian/ buster-updates main contrib non-free\ndeb-src [arch=amd64] http://ftp.no.debian.org/debian/ buster-updates main contrib non-free\n\ndeb [arch=amd64] http://security.debian.org/ buster/updates main contrib non-free\ndeb-src [arch=amd64] http://security.debian.org/ buster/updates main contrib non-free\n" | sudo tee sources.list;;
    
 #   3 ) echo -e "Sid (Unstable)";
 #       cd /etc/apt/;
 #       sudo cp sources.list sources.list.bak;
 #       echo "###### Debian Main Repos\ndeb [arch=amd64] http://ftp.no.debian.org/debian/ testing main contrib non-free\ndeb-src [arch=amd64] http://ftp.no.debian.org/debian/ testing main contrib non-free\n\ndeb [arch=amd64] http://ftp.no.debian.org/debian/ testing-updates main contrib non-free\ndeb-src [arch=amd64] http://ftp.no.debian.org/debian/ testing-updates main contrib non-free\n\ndeb [arch=amd64] http://security.debian.org/ testing/updates main contrib non-free\ndeb-src [arch=amd64] http://security.debian.org/ testing/updates main contrib non-free\n" | sudo tee sources.list;;
    
#    4 ) echo "Roll backup";
#        cd /etc/apt/;
#        sudo cp sources.list.bak sources.list -fv;;
#    n|N ) echo "No";;
#esac
#echo

##Install awesome & Xorg?
read -p "Install Awesome & Xorg? Y/n " option
echo
case "$option" in
    y|Y ) echo "Yes";
        sudo apt update;
        sudo apt install xorg -y;
        sudo apt install awesome -y;
    	ln -sfv $HOME/.dotfiles/awesome/ $HOME/.config/
	# don't forget to symlink all the fucking...theme files aswell RIP
    n|n ) echo "No";;
esac
echo

##Install Packages?
read -p "$(echo -e 'What Packages ?\n1: Laptop\n2: Workstation\n3: Server\n4: Minimal Server\n\b')" option
echo
case "$option" in
    1 ) echo "Laptop"; 
        sudo apt install fail2ban rofi neofetch mpv screen pulseaudio pavucontrol tmux python3-dev python3-pip python-dev python-pip alsa-utils rxvt-unicode-256color zsh moc virtualenv virtualenvwrapper dirmngr xbacklight wicd-curses firmware-iwlwifi -y;
        ln -svf /home/$USER/.dotfiles/configs/70-synaptics.conf /etc/X11/xorg.conf.d/70-synaptics.conf;;
    2 ) echo "Workstation"; 
        sudo apt install fail2ban rofi neofetch mpv screen pulseaudio pavucontrol tmux python3-dev python3-pip python-dev python-pip alsa-utils rxvt-unicode-256color zsh moc virtualenv virtualenvwrapper dirmngr -y;;
    3 ) echo "Server"; 
        sudo apt install fail2ban neofetch screen tmux python3-dev python3-pip python-dev python-pip zsh virtualenv virtualenvwrapper dirmngr -y;;
    4 ) echo "Minimal Server";
        sudo apt install fail2ban neofetch screen tmux zsh -y;;
    n|N ) echo "No";;
esac
echo

##Setup Unattended Upgrades (Security)
read -p "$(echo -e 'Setup Unattended Upgrades ?\n1: 20auto-upgrades,\n2: 02periodic\n\b')" option
echo
case "$option" in
    1 ) echo "20auto-upgrades";
        sudo apt install unattended-upgrades apt-listchanges -y; 
        echo 'APT::Periodic::Update-Package-Lists "1";\nAPT::Periodic::Unattended-Upgrade "1";' | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades;;
    2 ) echo "02periodic";
        echo "#TODO";;
    n|N ) echo "No";;
esac
echo

##Install gpu driver
read -p "$(echo -e 'What Driver ?\n1: NVIDIA (Without Optimus)\n2: NVIDIA (With Optimus)\n3: AMD\n\b')" option
echo
case "$option" in
    1 ) echo "NVIDIA (Without Optimus)"; 
        echo "#TODO";; #echo "# stretch-backports\ndeb http://httpredir.debian.org/debian stretch-backports main contrib non-free" | sudo tee -a && apt-get install linux-headers-$(uname -r|sed 's/[^-]*-[^-]*-//') && sudo apt update && apt install -t stretch-backports nvidia-driver -y
    2 ) echo "NVIDIA (With Optimus)";
        echo "#TODO";;
    3 ) echo "AMD"; 
        sudo apt update;
        sudo apt install firmware-amd-graphics -y;;
    n|N ) echo "No";;
esac
echo

##Install Vim plugins?
read -p "Install Vim plugins & oh-my-zsh? y/n " option
echo
case "$option" in
    y|Y ) echo "Yes";
        echo "installing NeoVim";
        curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage;
        chmod u+x nvim.appimage;
        sudo mv nvim.appimage /opt;
        sudo ln -s /opt/nvim.appimage /bin/vim;
        ln -s /home/$USER/.dotfiles/files/.vimrc /home/$USER/.config/nvim/init.vim
        pip3 install --upgrade neovim;
        echo "Installing Plug";
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
        echo "Installing oh-my-zsh";
        git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$USER/.oh-my-zsh;
        vim +PlugInstall +qall;
        ln -sfv $dir/Trilambda.zsh-theme /home/$USER/.oh-my-zsh/themes/Trilambda.zsh-theme;;
    n|n ) echo "No";;
esac
echo

##Install golang?
read -p "Install Golang? y/n " option
echo
case "$option" in
    y|Y ) echo "Yes";
        cd /tmp;
	wget  --prefer-family=ipv4 -O golang_tar https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz;
        tar xvf golang_tar;
        sudo mv go /usr/local;;
    n|n ) echo "No";;
esac
echo

# THIRD-PARTY APPLICATIONS
##Install Telegram
read -p "Install Telegram?  y/n " option
echo
case "$option" in
    y|Y ) echo "Install"; 
        cd /tmp 
        wget   --prefer-family=ipv4 -O linux https://telegram.org/dl/desktop/linux;
        tar xvf linux;
        sudo mv Telegram /opt/Telegram;
        sudo chown $USER:$USER /opt/Telegram -R;
        sudo ln -fvs /opt/Telegram/Telegram /bin/Telegram;
        sudo ln -fs /opt/Telegram/Updater /bin/Updater;;
    n|N ) echo "No";;
esac
echo

##Install Slack
read -p "Install Slack?  y/n " option
echo
case "$option" in
    y|Y ) echo "Install"; 
        cd /tmp;
        wget   --prefer-family=ipv4 -O slack.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-3.2.0-beta25a7a50e-amd64.deb;
        sudo dpkg -i slack.deb
        sudo apt-get -f install -y;;
    n|N ) echo "No";;
esac
echo

##Install firefox
read -p "Install Firefox?  y/n " option
echo
case "$option" in
    y|Y ) echo "Install"; cd /tmp 
        wget  --prefer-family=ipv4 -O firefax_tar https://download.mozilla.org/\?product\=firefox-latest-ssl\&os\=linux64\&lang\=en-US;
        tar xvf firefax_tar;
        sudo mv firefox /opt/;
        sudo chown $USER:$USER /opt/firefox -R;
        sudo ln -fvs /opt/firefox/firefox /bin/firefox;;
    n|N ) echo "No";;
esac
echo

##Install Docker
read -p "Install Docker?  y/n " option
echo
case "$option" in
    y|Y ) echo "Install"; 
        cd /tmp 
        sudo apt update;
        sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y;
        curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -;
        sudo $(curl -s https://docs.docker.com/install/linux/docker-ce/debian/\#set-up-the-repository | egrep "(apt-key fingerprint ([0-9A-F]{8}))" | cut -d'>' -f 9);
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable";
        sudo apt update;
        sudo apt install docker-ce -y;;
    n|N ) echo "No";;
esac
echo

##Install Docker-compose
read -p "Install Docker-compose?  y/n " option
echo
case "$option" in
    y|Y ) echo "Install";
        cd /tmp;
        sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose;
        sudo chmod +x /usr/local/bin/docker-compose;;
    n|N ) echo "No";;
esac
echo


##Install Spotify?
read -p "$(echo -e 'Install/ Update Spotify?\n1: Install\n2: Update\n\b')" option
echo
case "$option" in
    1 ) echo "Install"; 
        $(wget -qO- https://www.spotify.com/no/download/linux | egrep 'recv-keys\s\w+');
        echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list;
        sudo apt update;
        sudo apt install spotify-client -y;;
    2 ) echo "Update"; 
        $(wget -qO- https://www.spotify.com/no/download/linux | egrep 'recv-keys\s\w+');
        sudo apt update;
        sudo apt install spotify-client -y;;
    n|N ) echo "No";;
esac
echo

##Install Displaylink
read -p "Install Displaylink?  y/n " option
echo
case "$option" in
    y|Y ) echo "Install"; 
        cd /tmp
        wget https://raw.githubusercontent.com/AdnanHodzic/displaylink-debian/master/displaylink-debian.sh;
        sudo bash displaylink-debian.sh;;
    n|N ) echo "No";;
esac
echo

# PERSONAL SCRIPTS
##Install personal batch of script 
read -p "Install skandix toolbox of somewhat working scripts ?  y/n " option
echo
case "$option" in
    y|Y ) echo "Install";
        cd $HOME/.dotfiles;
        sudo cp scripts /opt/scripts;
        sudo chown $USER:$USER /opt/scripts -R;
        echo "symlink and crontab you self, have to fix..." ;;
    n|N ) echo "No";;
esac
echo


##remove beeping module
read -p "Remove the fucking beeping ?  y/n " option
echo
case "$option" in
    y|Y ) echo "Install";
        sudo modprobe -r pcspkr;
        echo "# Do not load 'pcspkr' module on boot\n#blacklist pcspkr" | sudo tee -a /etc/modprobe.d/nobeep.conf;;
    n|N ) echo "No";;
esac
echo

##Other
read -p "Do you want to allow, Permission fix and symlink of rc.lua and neofetch confg ?  y/n " option
echo
case "$option" in
    y|Y ) echo "Install";
        neofetch;
        sudo mv /etc/motd /etc/motd.back;
        sudo chown $USER:$USER /home/$USER -R;
        cd /home/$USER/.config/awesome/;
        cp rc.lua rc.lua.bak;
        ln -svf /home/$USER/.dotfiles/files/rc.lua /home/$USER/.config/awesome/rc.lua;
        ln -svf /home/$USER/.dotfiles/files/config_neofetch /home/$USER/.config/neofetch/config;
	cd /home/$USER/.config/awesome;
	git clone https://github.com/streetturtle/awesome-wm-widgets.git;
	sudo ln -svf /home/$USER/.dotfiles/files/theme.lua /usr/share/awesome/themes/default/theme.lua;;
    n|N ) echo "No";;
esac
echo


## TODO 
#TouchScreen
##https://boundarydevices.com/debian-in-more-depth-adding-touch-support/
