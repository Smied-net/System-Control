#!/bin/bash
##   _____           _          _                  _
##  / ____|         (_)        | |                | |
## | (___  _ __ ___  _  ___  __| |      _ __   ___| |_
##  \___ \| '_ ` _ \| |/ _ \/ _` |     | '_ \ / _ \ __|
##  ____) | | | | | | |  __/ (_| |  _  | | | |  __/ |_
## |_____/|_| |_| |_|_|\___|\__ _| (_) |_| |_|\___|\__|
##
# ENG: Font - big (ascii)
# RUS: Шрифт - big (ascii)
##
# ENG: System Control 
# ENG: Copyright (c) Smied :: support@smied.net
#
# RUS: Управление системой
# RUS: Авторское право (c) Smied :: support@smied.net
##
##
## Usage: System Control  [options]
##
## Options:
##   -h, --help         Show this help
##   -v, --version      Print version info
##

#=======================================================================================================================
# Globals
#=======================================================================================================================

    ARGV=$@
    INSTALLERVERSION="1.0 (01.05.2021)"

#=======================================================================================================================
# Functions | Script | Common
#=======================================================================================================================

    # ENG: Prints a given message and highlight it.
    # RUS: Печатает заданное сообщение и выделяет его.

    function die()
    {
        echo -en "\033[1;31mERROR:\033[0m "
        echo "$*" >&2
        exit 1
    }

    # ENG: Prints a given message and highlight it.
    # RUS: Печатает заданное сообщение и выделяет его.

    function warn()
    {
        echo -en "\033[1;33mWARNING:\033[0m "
        echo "$*" >&2
    }

    # ENG: Prints a given message and highlight it.
    # RUS: Печатает заданное сообщение и выделяет его.

    function printHeadline()
    {
        printf "\n\033[1;32m-> $*\033[0m\n"
    }

    # ENG: Parses command line arguments and store them in global variables.
    # RUS: Анализирует аргументы командной строки и сохраняет их в глобальных переменных.

    function parse_args()
    {
        while [[ $# > 0 ]]
        do
            key="$1"
            case $key in
                -h|--help)
                    echo "$(grep '^##' "${BASH_SOURCE[0]}" | cut -c 4-)"
                    echo ""
                    exit 0
                    ;;
                -v|--version)
                    echo "Version: $INSTALLERVERSION"
                    echo "Copyright (c) `date +'%Y'` Smied.net"
                    exit 0
                    ;;
            esac
            shift
        done
    }

#=======================================================================================================================
# Functions | Script | Initial checks
#=======================================================================================================================

    # ENG: Checks, if current user has sudo privileges.
    # RUS: Проверяет, имеет ли текущий пользователь права sudo.
    function check_root()
    {
        if [ `id -u` -ne 0 ]; then
            # ENG: You need super-user (root) privileges to use System Control
            # RUS: Вам нужны права супер-пользователя (root) для использования System Control
            die "You need super-user (root) privileges to use System Control"
        fi
    }


#=======================================================================================================================
# Menu | OS | Clean
#=======================================================================================================================

#===============
# Ubuntu
#===============

function  clean_ubuntu {
# ENG: restore dependencies
# RUS: восстановление зависимостей
sudo apt install -y -f
# ENG: removing unnecessary packages, cleaning the APT cache
# RUS: удаление лишних пакетов, чистка кеша APT
sudo apt autoremove -y
sudo apt-get autoclean -y
}

function  update_ubuntu {
# ENG: system update
# RUS: обновление системы
sudo apt-get full-upgrade
# обновление репозиториев
sudo apt-get update
}

function  update-disable_ubuntu {
# ENG: Disabling updates
# RUS: Отключение обновлений
sed -i 's/1/0/' /etc/apt/apt.conf.d/20auto-upgrades;
echo -e 'Updates disabled'
}

function  update-enable_ubuntu {
# ENG: Enabling updates
# RUS: Включение обновлений
sed -i 's/0/1/' /etc/apt/apt.conf.d/20auto-upgrades;
echo -e 'Updates enabled'
}

function  set_ubuntu_root-connect {
# ENG: Enabling remote root user connectivity
# RUS: Включение возможности удаленного подключения root пользователя
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; sudo service ssh restart
echo -e 'Root ssh connect enabled'
}

function  set_ubuntu_root-password {
# ENG: Setting the password for the root user
# RUS: Установка пароля для root пользователя
sudo passwd root
}

#=======================================================================================================================
# Menu | Apps
#=======================================================================================================================

    function  install_docker {
    #Install docker       
    sudo apt install docker.io -y                                                                               
    #Start docker         
    sudo systemctl start docker                                                                                 
    #Autostart docker     
    sudo systemctl enable docker                                                                                
    #Freeing port 53
    sudo systemctl stop systemd-resolved && sudo systemctl disable systemd-resolved && sudo rm /etc/resolv.conf && sudo echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" >> /etc/resolv.conf && sudo sed -i 's/main]/main] \ndns=default/' /etc/NetworkManager/NetworkManager.conf && sudo service network-manager restart
    }

#=======================================================================================================================
# Menu
#=======================================================================================================================

    # ENG: Logo
    # RUS: Логотип
    logo () {
    echo
    echo -e '\e[1;32m   _____           _                    _____            _             _ \e[0m'
    echo -e '\e[1;32m  / ____|         | |                  / ____|          | |           | |\e[0m'
    echo -e '\e[1;32m | (___  _   _ ___| |_ ___ _ __ ___   | |     ___  _ __ | |_ _ __ ___ | |\e[0m'
    echo -e '\e[1;32m  \___ \| | | / __| __/ _ \  _   _ \  | |    / _ \|  _ \| __|  __/ _ \| |\e[0m'
    echo -e '\e[1;32m  ____) | |_| \__ \ ||  __/ | | | | | | |___| (_) | | | | |_| | | (_) | |\e[0m'
    echo -e '\e[1;32m |_____/ \__, |___/\__\___|_| |_| |_|  \_____\___/|_| |_|\__|_|  \___/|_|\e[0m'
    echo -e '\e[1;32m          __/ |                                                          \e[0m'
    echo -e '\e[1;32m         |___/                                                           \e[0m'
    echo
    echo -e '                                                        https://Smied.net'
    echo
    echo 'System Control  - user friendly script to manage the system:'
    echo 'Linux (Ubuntu)'
    echo -e '\n'
    echo 'Tip - To cancel the command, press (CTRL + Z)'
    echo -e '\n'
    }

    # ENG: Main menu
    # RUS: Главное меню
    menu () {
    PS3='Main menu selection: '
    echo -e "\e[1;32mMain Menu\e[0m"
    options=('Web Server CP' 'Game Server CP' 'Apps' 'System' 'Tools'  'Exit the program')
    select opt in "${options[@]}"
    do
        case $opt in
            'Web Server CP')
                clear; logo; submenu1
                ;;
            'Game Server CP')
                clear; logo; submenu2
                ;;
            'Apps')
                clear; logo; submenu3
                ;;
            'System')
                clear; logo; submenu4
                ;;
            'Tools')
                clear; logo; submenu5
                ;;
            'Exit the program')
                exit
                ;;
            *) clear; logo; menu;;
        esac
    done
    }

    # ENG: Submenu1 (Web Server Control Panels)
    # RUS: Подменю1 (Панели управления веб-сервером)
    submenu1 () {
      local PS3='Select: '
      echo -e "\e[1;32mChoose Web Server Control Panel\e[0m"
      local options=("Hestia CP" "KeyHelp" "Brainy CP" "Vesta CP" "Virtualmin" "Ispconfig" "Back to the Menu")
      local opt
      select opt in "${options[@]}"
      do
          case $opt in
              "Hestia CP")
                  clear; logo; wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh && bash hst-install.sh; exit
                  ;;
              "KeyHelp")
                  clear; logo; wget https://install.keyhelp.de/get_keyhelp.php -O installkeyhelp.sh ; bash installkeyhelp.sh; exit
                  ;;
              "Brainy CP")
                  clear; logo; yum clean all && yum install -y wget && wget http://core.brainycp.com/install.sh && bash ./install.sh; exit
                  ;;
              "Vesta CP")
                  clear; logo; curl -O http://vestacp.com/pub/vst-install.sh; bash vst-install.sh --force; exit
                  ;;
              "Virtualmin")
                  clear; logo; wget http://software.virtualmin.com/gpl/scripts/install.sh; bash install.sh; exit
                  ;;
              "Ispconfig")
                  clear; logo; cd /tmp; wget -O installer.tgz "https://github.com/servisys/ispconfig_setup/tarball/master"; tar zxvf installer.tgz; cd *ispconfig*; sudo bash install.sh; exit
                  ;;
              "Back to the Menu")
                  clear; logo; menu
                  ;;
              *) clear; logo; submenu1;;
          esac
      done
    }

    # ENG: Submenu2 (Game Server Control Panels)
    # RUS: Подменю2 (Панели управления Игровым Сервером)
    submenu2 () {
      local PS3='Select: '
      echo -e "\e[1;32mВыбор Game Server Control Panels\e[0m"
      local options=("GameAp.ru" "Back to the Menu")
      local opt
      select opt in "${options[@]}"
      do
          case $opt in
              "GameAp.ru")
                  clear; logo; curl -sLO http://packages.gameap.ru/installer.sh && bash installer.sh; exit
                  ;;
              "Back to the Menu")
                  clear; logo; menu
                  ;;
              *) clear; logo; submenu2;;
          esac
      done
    }

    # ENG: Submenu3 (Apps)
    # RUS: Подменю3 (Приложения)
    submenu3 () {
      local PS3='Select: '
      echo -e "\e[1;32mSelecting a utility\e[0m"
      local options=("Docker" "Back to the Menu")
      local opt
      select opt in "${options[@]}"
      do
          case $opt in
              "Docker")
                clear; logo; submenu3_docker
                ;;
              "Back to the Menu")
                  clear; logo; menu
                  ;;
              *) clear; logo; submenu3;;
          esac
      done
    }

    # ENG: Submenu3_docker (Apps)
    # RUS: Подменю3_докер (Приложения)
    submenu3_docker () {
      local PS3='Select: '
      echo -e "\e[1;32mSelecting a utility\e[0m"
      local options=("Install Docker" "Status containers" "Status process" "Status Storage" "Clean" "Start" "Stop" "Restart" "Back to the Menu")
      local opt
      select opt in "${options[@]}"
      do
          case $opt in
              "Install Docker")
                clear; logo; install_docker; read -p "Press ENTER to continue"; clear; logo; submenu3_docker
                ;;
              "Status containers")
                clear; logo; docker ps -a; read -p "Press ENTER to continue"; clear; logo; submenu3_docker
                ;;
              "Status process")
                clear; logo; systemctl status docker; read -p "Press ENTER to continue"; clear; logo; submenu3_docker
                ;;
              "Status Storage")
                clear; logo; docker system df; read -p "Press ENTER to continue"; clear; logo; submenu3_docker
                ;;
              "Clean")
                clear; logo; docker system prune; read -p "Press ENTER to continue"; clear; logo; submenu3_docker
                ;;
              "Start")
                clear; logo; sudo systemctl start docker; read -p "Press ENTER to continue"; clear; logo; submenu3_docker
                 ;;
              "Stop")
                clear; logo; sudo systemctl stop docker; read -p "Press ENTER to continue"; clear; logo; submenu3_docker
                 ;;
              "Restart")
                clear; logo; sudo systemctl stop docker && sudo systemctl start docker; read -p "Press ENTER to continue"; clear; logo; submenu3_docker
                 ;;
              "Back to the Menu")
                clear; logo; menu
                ;;
              *) clear; logo; submenu3_docker;;
          esac
      done
    }

    # ENG: Submenu4 (System)
    # RUS: Подменю4 (Система)
    submenu4 () {
      local PS3='Select: '
      echo -e "\e[1;32mSelecting a utility\e[0m"
      local options=("Clean" "Update" "Disable Updates" "Enable Updates" "Root ssh connect" "Set root password" "Shutdown" "Reboot" "Back to the Menu")
      local opt
      select opt in "${options[@]}"
      do
          case $opt in
              "Clean")
                clear; logo; clean_ubuntu; read -p "Press ENTER to continue"; clear; logo; submenu4
                ;;
              "Update")
                clear; logo; update_ubuntu; read -p "Press ENTER to continue"; clear; logo; submenu4
                ;;
              "Disable Updates")
                clear; logo; update-disable_ubuntu; read -p "Press ENTER to continue"; clear; logo; submenu4
                ;;
              "Enable Updates")
                clear; logo; update-enable_ubuntu; read -p "Press ENTER to continue"; clear; logo; submenu4
                ;;
              "Root ssh connect")
                clear; logo; set_ubuntu_root-connect; read -p "Press ENTER to continue"; clear; logo; submenu4
                ;;
              "Set root password")
                clear; logo; set_ubuntu_root-password; read -p "Press ENTER to continue"; clear; logo; submenu4
                ;;
              "Shutdown")
                  clear; logo; sudo shutdown now; exit
                  ;;
              "Reboot")
                  clear; logo; sudo reboot; exit
                  ;;
              "Back to the Menu")
                  clear; logo; menu
                  ;;
              *) clear; logo; submenu4;;
          esac
      done
    }

    # ENG: Submenu5 (Tools)
    # RUS: Подменю5 (Инструменты)
    submenu5 () {
      local PS3='Select: '
      echo -e "\e[1;32mSelecting a utility\e[0m"
      local options=("Ifconfig" "Netstat" "OpenVPN" "Back to the Menu")
      local opt
      select opt in "${options[@]}"
      do
          case $opt in
              "Ifconfig")
                clear; logo; /sbin/ifconfig; read -p "Press ENTER to continue"; clear; logo; submenu5
                ;;
              "Netstat")
                  clear; logo; netstat -tulpn; read -p "Press ENTER to continue"; clear; logo; submenu5
                  ;;
               "OpenVPN")
                clear; logo; wget https://raw.githubusercontent.com/Nyr/openvpn-install/master/openvpn-install.sh -O openvpn-install.sh && bash openvpn-install.sh; exit
                ;;
              "Back to the Menu")
                  clear; logo; menu
                  ;;
              *) clear; logo; submenu5;;
          esac
      done
    }



#=======================================================================================================================
# Run | Script |
#=======================================================================================================================

    # ENG: Parse for --help parameter
    # RUS: Парсинг для параметра --help
    parse_args $ARGV

    # ENG: Check
    # RUS: Проверка
    printHeadline "Preparing System Control ..."

    # ENG: Loading the menu
    # RUS: Загрузка меню
    clear
    logo
    menu
