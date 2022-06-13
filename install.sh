#!/bin/bash

#Clear Screen 
clear
#Location for Paru
PARU=/usr/bin/paru

# Checking Packing Manager
declare -A osInfo;
osInfo[/etc/debian_version]="apt-get"
osInfo[/etc/alpine-release]="apk"
osInfo[/etc/centos-release]="yum"
osInfo[/etc/fedora-release]="dnf"
osInfo[/etc/arch-release]="pacman"

#to find the which Os yo are running
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];
    then
         package_manager=${osInfo[$f]}
    fi
done


function welcome()
{
  echo '###################################################################################### '
  echo '#                                                                                    # '
  echo '#                 ####  Author: Mohammad Abdul Rafay          #####                  # '
  echo '#                 ####  Email : 99marafay@gmail.com           #####                  # '
  echo '#                 ####  GitHub: rafay99-epic                  #####                  # '
  echo '#                 ####  Project: Fish Shell Project           #####                  # '
  echo '#                                                                                    # '
  echo '###################################################################################### '
}

function bye() 
{
    echo -ne "
-------------------------------------------------------------------------
          Thank You For Using this Script!!
          
          All Done...✨Congratulation✨              
-------------------------------------------------------------------------
" 
}

# To check the file is run as non root
function non-root() 
{
    clear
    if [ "$USER" = root ]; then
        echo -ne "
-------------------------------------------------------------------------
          This script shouldn't be run as root. ☹️🙁

          Run script like this:-  ./install.sh
-------------------------------------------------------------------------
"      
        bye
        exit 1
    fi
}


function package_manager()
{
    if [[ "$package_manager" == "pacman" ]];
then    
    Arch_Linux
elif [[ "$package_manager" == "apt-get" ]];
then 
    echo "Debian is Detected"
    Debian_Linux
else
    echo "Unknown OS detected!! Sorry!"
    exit 1
fi
}

# Installing Startship Promote
function starship_promote()
{ 
    echo -ne "
-------------------------------------------------------------------------
           Installing Startship Promote
-------------------------------------------------------------------------
"  
    curl -sS https://starship.rs/install.sh | sh
}

# Installing of fm6000
function fm6000()
{
    echo -ne "
-------------------------------------------------------------------------
           Installing FM6000
-------------------------------------------------------------------------
"
    sh -c "$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)"
}

# Customizing Startship Promote 
function starship_promote_customize()
{
    echo -ne "
-------------------------------------------------------------------------
           --- Customizing Startship Promote ---

Do you want to Customize the Starship prmote??
Enter your Choice: 
                 Yes to Customize  
                 No  to Default Look 
-------------------------------------------------------------------------
"
    read -p "--- Enter your Choice ---: " user_choice

    if [[ "$user_choice" == "yes" || "$user_choice" == "Yes" || "$user_choice" == "YES" || "$user_choice" == "yEs" || "$user_choice" == "yeS"  ]];
    then
        echo "Customizing Startship Promote: "
        cp -r starship.toml ~/.config
        echo "Customizing is Done"   
    elif [[ "$user_choice" == "no" || "$user_choice" == "No" || "$user_choice" == "nO" || "$user_choice" == "NO" ]];
    then     
        echo "There is no customizing to the promote.."    
    fi
}
# Configuring Fish shell
function config_fish()
{   
        echo -ne "
-------------------------------------------------------------------------
          --- Configuring Fish Shell --- 
-------------------------------------------------------------------------
"
    cp -r fish ~/.config
}
# Changing Default Shell
function change_shell() 
{ 
    echo -ne "
-------------------------------------------------------------------------
                Changing Default Shell  
-------------------------------------------------------------------------
"  
    if [[ "$package_manager" == "pacman" ]];
    then
        chsh -s /bin/fish
    elif [[ "$package_manager" == "apt-get" ]];
    then
        chsh -s /usr/bin/fish
    else
        echo 'Error Occured: ${package_manager}'
        exit 0
    fi  
}


# Arch Linux Part Function
function Arch_Linux()
{
    clear
echo -ne "
-------------------------------------------------------------------------
           Arch Linux is Detected!!
-------------------------------------------------------------------------
" 
    packages_arch
    fm6000
    config_fish
    starship_promote
    starship_promote_customize
    change_shell
}

# Installing Applications
function packages_arch()
{
    echo -ne "
-------------------------------------------------------------------------
         Installing Applications
-------------------------------------------------------------------------
"    
    if [ ! -e "$PARU" ]; 
        then
            echo -ne "
-------------------------------------------------------------------------
           Installing Rust
-------------------------------------------------------------------------
"
            sudo pacman -S rust --noconfirm --needed 
            
            echo -ne "
-------------------------------------------------------------------------
           Installing Base System for ARU-Helper
-------------------------------------------------------------------------
"
            # Installing Paru 
            sudo pacman -S base-devel --noconfirm --needed
            echo -ne "
-------------------------------------------------------------------------
               Installing Paru
-------------------------------------------------------------------------
" 
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si
            cd ../
        else
            echo -ne "
-------------------------------------------------------------------------
           Paru is Already Detected!!
-------------------------------------------------------------------------
"
    fi

echo -ne "
-------------------------------------------------------------------------
           Installing Fish Shell
-------------------------------------------------------------------------
" 
    # Installing Fish shell
    sudo pacman -S fish --noconfirm --needed

    # Installing Lsd for arch
echo -ne "
-------------------------------------------------------------------------
           Installing LSD Package
-------------------------------------------------------------------------
"   
    sudo pacman -S lsd --noconfirm --needed

    # Installing ccat
echo -ne "
-------------------------------------------------------------------------
           Installing ccat Package
-------------------------------------------------------------------------
"
    paru -S ccat --noconfirm --needed

    echo -ne "
-------------------------------------------------------------------------
           Installing  Powerline-font
-------------------------------------------------------------------------
"
    paru -R ttf-hack --noconfirm --needed   
    paru -S powerline-fonts-git --noconfirm --needed
    
    echo -ne "
-------------------------------------------------------------------------
           Installing  Awesome-font
-------------------------------------------------------------------------
"   
    paru -S ttf-font-awesome --noconfirm --needed
    echo -ne "  
-------------------------------------------------------------------------
            Install Nerd Fonts
            1. Nerd Mononoki Font
            2. Meslo Nerd Font Power10K
            3. Meslo Storm Font
-------------------------------------------------------------------------
"
    paru -S nerd-fonts-mononoki --noconfirm --needed
    paru -S ttf-meslo-nerd-font-powerlevel10k --noconfirm --needed
    paru -S nerd-fonts-meslo --noconfirm --needed

    cp -r NerdFonts  ~/.local/share
}

#  Debian and Ubuntu   Functions
function Debian_Linux()
{
    clear
echo -ne "
-------------------------------------------------------------------------
           Debian Linux is Detected!!
-------------------------------------------------------------------------
" 
    package_debian
    fm6000
    config_fish
    starship_promote
    starship_promote_customize
    change_shell
}

# Isntalling Applicatins on Debian 
function package_debian()
{   
    echo -ne "
-------------------------------------------------------------------------
         Installing Applications
-------------------------------------------------------------------------
"

echo -ne "
-------------------------------------------------------------------------
           Installing Fish Shell
-------------------------------------------------------------------------
"   
    # Isntalling fish
    sudo apt-get install fish -y
    
    echo -ne "
-------------------------------------------------------------------------
           Installing LSD Package
-------------------------------------------------------------------------
"
    # Installing lsd 
    sudo dpkg -i lsd.deb

    echo -ne "
-------------------------------------------------------------------------
           --- Installing Fonts ---

           1. Powerline Fonts
           2. Font Awesome Fonts
-------------------------------------------------------------------------
"
    sudo apt-get install fonts-powerline -y
    sudo apt-get install fonts-font-awesome -y
    sudo apt-get install fonts-mononoki -y
    sudo apt-get install fontconfig -y

    # Install powerline fonts
    cd ~
    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
    mkdir ~/.fonts #if directory doesn't exist
    mv PowerlineSymbols.otf ~/.fonts/
    mkdir -p ~/.config/fontconfig/conf.d #if directory doesn't exists

    # Cache the font
    fc-cache -vf ~/.fonts/
    
    # moving the fonts
    mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/


    cd ~
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
    mkdir -p .local/share/fonts
    unzip Meslo.zip -d .local/share/fonts
    cd .local/share/fonts
    rm *Windows*
    cd ~
    rm Meslo.zip
    fc-cache -fv
    
    cp -r NerdFonts  ~/.local/share
}

function runner()
{
    welcome
    # Check non root
    non-root

    # check package manager
    package_manager
    
    bye
}
runner

