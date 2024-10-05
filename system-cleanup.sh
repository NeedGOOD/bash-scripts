#!/bin/bash

# Function to clear the trash
clear_trash() {
  local trash_dir="$HOME/.local/share/Trash/files"
  if [ -d "$trash_dir" ]; then
    echo "Clearing the trash..."
    rm -rf "$trash_dir/*"
    echo "Trash has been cleared."
  else
    echo "Trash directory not found."
  fi
}

# Function to perform a system update
system_update() {
  local pm=$1
  case $pm in
    apt)
      sudo apt update && sudo apt upgrade -y
      ;;
    dnf)
      sudo dnf check-update && sudo dnf upgrade -y
      ;;
    pacman)
      sudo pacman -Syu --noconfirm
      ;;
    *)
      echo "Unsupported package manager."
      exit 1
      ;;
  esac
}

# Function to clean up unnecessary packages
clean_system() {
  local pm=$1
  case $pm in
    apt)
      sudo apt autoremove -y && sudo apt clean
      ;;
    dnf)
      sudo dnf autoremove -y && sudo dnf clean all
      ;;
    pacman)
      sudo pacman -Rns $(pacman -Qdtq) --noconfirm
      ;;
    *)
      echo "Unsupported package manager."
      exit 1
      ;;
  esac
}

# Get the name of the distribution
name=$(grep '^NAME=' /etc/os-release | cut -d '=' -f 2 | tr -d '"' | cut -d ' ' -f 1)

# Determine the package manager based on the distribution name
case $name in
  Ubuntu)
    pm="apt"
    ;;
  Fedora)
    pm="dnf"
    ;;
  Arch | "Arch Linux")
    pm="pacman"
    ;;
  *)
    echo "Package manager not supported yet."
    exit 1
    ;;
esac

# Ask the user what action to perform
echo "What do you want to do?"
echo "Working on Ubuntu, Fedora and Arch."
echo "1. Update system;"
echo "2. Clean up unnecessary packages;"
echo "3. Clear trash;"
echo "4. Exit."
read -r number

# Perform the action based on the user's choice
case $number in
  1) system_update "$pm" ;;
  2) clean_system "$pm" ;;
  3) clear_trash ;;
  4) echo "Exiting..."; exit 0 ;;
  *) echo "Invalid option. Exiting."; exit 1 ;;
esac

echo "Operation completed."
