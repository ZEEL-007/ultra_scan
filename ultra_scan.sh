#!/bin/bash

# Trap Ctrl+C
trap "echo -e '\n\e[1;31mAborted by user. Exiting...\e[0m'; exit" SIGINT

# Function to check and install dependencies
function check_dependencies() {
    local deps=("nmap" "figlet")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo -e "\e[1;31mMissing dependency:\e[0m $dep"
            read -p "Do you want to install $dep? (y/n): " choice
            if [[ "$choice" =~ ^[Yy]$ ]]; then
                sudo apt update
                sudo apt install "$dep" -y
            else
                echo -e "\e[1;31mCannot continue without $dep. Exiting...\e[0m"
                exit 1
            fi
        fi
    done
}

# Function to display animated header
function show_header() {
    clear
    echo -ne "\e[1;34mInitializing Ultra Scan"
    for i in {1..3}; do
        sleep 0.5
        echo -n "."
    done
    echo -e "\e[0m\n"
    sleep 0.5

    CYAN="\e[1;36m"
    YELLOW="\e[1;33m"
    RESET="\e[0m"

    echo -e "${CYAN}"
    figlet -c " ULTRA SCAN " | while IFS= read -r line; do
        echo "$line"
        sleep 0.08
    done
    echo -e "${RESET}"

    local text=(
        "${YELLOW}Author    : Zeel Kotadiya"
        "Instagram : __mr.kotadiya__${RESET}"
        "----------------------------------------------"
        ""
    )
    for line in "${text[@]}"; do
        echo -e "$line"
        sleep 0.2
    done
}

# Run dependency check
check_dependencies

# Function to handle scan and optional output
function run_scan() {
    local scan_cmd="$1"
    local target="$2"

    read -p "Do you want to save the output? (y/n): " save_choice
    if [[ "$save_choice" =~ ^[Yy]$ ]]; then
        read -p "Enter desired output format (txt, html, xml, json, gnmap): " format
        folder="$(dirname "$0")/results/$target"
        mkdir -p "$folder"
        case "$format" in
            txt)
                eval "$scan_cmd" > "$folder/output.txt"
                echo -e "\e[1;32mSaved as $folder/output.txt\e[0m"
                ;;
            html)
                eval "$scan_cmd" -oX "$folder/output.xml"
                xsltproc "$folder/output.xml" -o "$folder/output.html"
                echo -e "\e[1;32mSaved as $folder/output.html\e[0m"
                ;;
            xml)
                eval "$scan_cmd" -oX "$folder/output.xml"
                echo -e "\e[1;32mSaved as $folder/output.xml\e[0m"
                ;;
            json)
                eval "$scan_cmd" -oX "$folder/output.xml"
                xml2json < "$folder/output.xml" > "$folder/output.json"
                echo -e "\e[1;32mSaved as $folder/output.json\e[0m"
                ;;
            gnmap)
                eval "$scan_cmd" -oG "$folder/output.gnmap"
                echo -e "\e[1;32mSaved as $folder/output.gnmap\e[0m"
                ;;
            *)
                echo -e "\e[1;31mUnsupported format. Running scan without saving.\e[0m"
                eval "$scan_cmd"
                ;;
        esac
    else
        eval "$scan_cmd"
    fi
}

# Main Loop
while true; do
    show_header

    echo -e "\e[1;32mSelect scan type:\e[0m"
    options=(
        "1.  Ping Scan"
        "2.  TCP SYN Scan"
        "3.  UDP Scan"
        "4.  OS Detection"
        "5.  Version Detection"
        "6.  Aggressive Scan"
        "7.  Fast Scan"
        "8.  All Ports Scan"
        "9.  Top Ports Scan"
        "10. Firewall Evasion"
        "11. Vulnerability Scan"
        "12. NSE Script Scan"
        "13. Decoy Scan"
        "14. Traceroute"
        "15. Custom Ports"
        "16. Output to File"
        "17. Spoof MAC"
        "18. DNS Brute Force"
        "19. HTTP Title Enumeration"
        "20. SMB Enumeration"
        "21. FTP Anonymous Login Check"
        "22. SSL Certificate Info"
        "23. Detect Web Application Firewall"
        "24. HTTP Methods Check"
        "25. Extract HTTP Robots.txt"
        "26. Whois Lookup"
        "27. Run All Safe Scripts"
        "28. Exit"
    )

    for opt in "${options[@]}"; do
        echo "$opt"
        sleep 0.05
    done

    echo -ne "\nEnter option number: "
    read opt

    case $opt in
        1)  read -p "Enter target: " target; run_scan "nmap -sn $target" "$target" ;;
        2)  read -p "Enter target: " target; run_scan "nmap -sS $target" "$target" ;;
        3)  read -p "Enter target: " target; run_scan "nmap -sU $target" "$target" ;;
        4)  read -p "Enter target: " target; run_scan "nmap -O $target" "$target" ;;
        5)  read -p "Enter target: " target; run_scan "nmap -sV $target" "$target" ;;
        6)  read -p "Enter target: " target; run_scan "nmap -A $target" "$target" ;;
        7)  read -p "Enter target: " target; run_scan "nmap -F $target" "$target" ;;
        8)  read -p "Enter target: " target; run_scan "nmap -p- $target" "$target" ;;
        9)  read -p "Enter target: " target; run_scan "nmap --top-ports 100 $target" "$target" ;;
        10) read -p "Enter target: " target; run_scan "nmap -f --data-length 200 $target" "$target" ;;
        11) read -p "Enter target: " target; run_scan "nmap --script vuln $target" "$target" ;;
        12) read -p "Enter target: " target; run_scan "nmap --script default,vuln $target" "$target" ;;
        13) read -p "Enter target: " target; read -p "Enter decoy IP (or RND:10): " decoy; run_scan "nmap -D $decoy $target" "$target" ;;
        14) read -p "Enter target: " target; run_scan "nmap --traceroute $target" "$target" ;;
        15) read -p "Enter target: " target; read -p "Enter ports (e.g. 21,22,80): " ports; run_scan "nmap -p $ports $target" "$target" ;;
        16) read -p "Enter target: " target; run_scan "nmap -A $target" "$target" ;;
        17) read -p "Enter target: " target; read -p "Enter MAC type (e.g. 0=random): " mac; run_scan "nmap --spoof-mac $mac $target" "$target" ;;
        18) read -p "Enter domain: " target; run_scan "nmap --script dns-brute $target" "$target" ;;
        19) read -p "Enter target: " target; run_scan "nmap --script http-title $target" "$target" ;;
        20) read -p "Enter target: " target; run_scan "nmap --script smb-enum-shares,smb-enum-users $target" "$target" ;;
        21) read -p "Enter target: " target; run_scan "nmap --script ftp-anon $target" "$target" ;;
        22) read -p "Enter target: " target; run_scan "nmap --script ssl-cert $target" "$target" ;;
        23) read -p "Enter target: " target; run_scan "nmap --script http-waf-detect $target" "$target" ;;
        24) read -p "Enter target: " target; run_scan "nmap --script http-methods $target" "$target" ;;
        25) read -p "Enter target: " target; run_scan "nmap --script http-robots.txt $target" "$target" ;;
        26) read -p "Enter target: " target; run_scan "nmap --script whois $target" "$target" ;;
        27) read -p "Enter target: " target; run_scan "nmap --script safe $target" "$target" ;;
        28) echo -e "\n\e[1;31mExiting Ultra Scan... Goodbye!\e[0m"; exit 0 ;;
        *) echo -e "\e[1;31mInvalid option. Try again.\e[0m" ;;
    esac

    echo -e "\nPress ENTER to return to menu..."
    read

    clear

done

