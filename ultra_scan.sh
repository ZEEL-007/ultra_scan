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
        1)
            read -p "Enter target: " target
            nmap -sn "$target"
            ;;
        2)
            read -p "Enter target: " target
            nmap -sS "$target"
            ;;
        3)
            read -p "Enter target: " target
            nmap -sU "$target"
            ;;
        4)
            read -p "Enter target: " target
            nmap -O "$target"
            ;;
        5)
            read -p "Enter target: " target
            nmap -sV "$target"
            ;;
        6)
            read -p "Enter target: " target
            nmap -A "$target"
            ;;
        7)
            read -p "Enter target: " target
            nmap -F "$target"
            ;;
        8)
            read -p "Enter target: " target
            nmap -p- "$target"
            ;;
        9)
            read -p "Enter target: " target
            nmap --top-ports 100 "$target"
            ;;
        10)
            read -p "Enter target: " target
            nmap -f --data-length 200 "$target"
            ;;
        11)
            read -p "Enter target: " target
            nmap --script vuln "$target"
            ;;
        12)
            read -p "Enter target: " target
            nmap --script default,vuln "$target"
            ;;
        13)
            read -p "Enter target: " target
            read -p "Enter decoy IP (or RND:10): " decoy
            nmap -D "$decoy" "$target"
            ;;
        14)
            read -p "Enter target: " target
            nmap --traceroute "$target"
            ;;
        15)
            read -p "Enter target: " target
            read -p "Enter ports (e.g. 21,22,80): " ports
            nmap -p "$ports" "$target"
            ;;
        16)
            read -p "Enter target: " target
            read -p "Output filename (no extension): " filename
            nmap -A -oA "$filename" "$target"
            ;;
        17)
            read -p "Enter target: " target
            read -p "Enter MAC type (e.g. 0=random): " mac
            nmap --spoof-mac "$mac" "$target"
            ;;
        18)
            read -p "Enter domain: " target
            nmap --script dns-brute "$target"
            ;;
        19)
            read -p "Enter target: " target
            nmap --script http-title "$target"
            ;;
        20)
            read -p "Enter target: " target
            nmap --script smb-enum-shares,smb-enum-users "$target"
            ;;
        21)
            read -p "Enter target: " target
            nmap --script ftp-anon "$target"
            ;;
        22)
            read -p "Enter target: " target
            nmap --script ssl-cert "$target"
            ;;
        23)
            read -p "Enter target: " target
            nmap --script http-waf-detect "$target"
            ;;
        24)
            read -p "Enter target: " target
            nmap --script http-methods "$target"
            ;;
        25)
            read -p "Enter target: " target
            nmap --script http-robots.txt "$target"
            ;;
        26)
            read -p "Enter target: " target
            nmap --script whois "$target"
            ;;
        27)
            read -p "Enter target: " target
            nmap --script safe "$target"
            ;;
        28)
            echo -e "\n\e[1;31mExiting Ultra Scan... Goodbye!\e[0m"
            exit 0
            ;;
        *)
            echo -e "\e[1;31mInvalid option. Try again.\e[0m"
            ;;
    esac

    echo -e "\nPress ENTER to return to menu..."
    read
done

