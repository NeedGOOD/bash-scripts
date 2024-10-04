#!/bin/bash

# Function to clear the trash
clear_trash() {
  if [ -d "$HOME/.local/share/Trash/files" ]; then
    # Clear the trash in GNOME
    echo "Clearing the trash..."
    rm -rf "$HOME/.local/share/Trash/files/*"
    echo "Trash has been cleared."
  else
    echo "Trash directory not found."
  fi
}

# Get the name of the distribution
name=$(grep '^NAME=' /etc/os-release | cut -d '=' -f 2 | tr -d '"' | cut -d ' ' -f 1)

pm=""
# Determine the package manager based on the distribution name
if [ "$name" == "Ubuntu" ]; then
	pm="apt"
elif [ "$name" == "Fedora" ]; then
	pm="dnf"
elif [[ "$name" == "Arch" || "$name" == "Arch Linux" ]]; then
  pm="pacman"
else
  echo "Package manager not supported yet."
  exit 1
fi

# Ask the user what action to perform
echo "What do you want to do?"
echo "1. Update system;"
echo "2. Clean up unnecessary packages;"
echo "3. Clear trash;"
echo "4. Exit."
read number

# System update
if [ "$number" == "1" ]; then
  # Update for apt (Ubuntu-based systems)
  if [ "$pm" == "apt" ]; then
    sudo apt update && sudo apt upgrade -y
  # Update for dnf (Fedora-based systems)
  elif [ "$pm" == "dnf" ]; then
    sudo dnf check-update && sudo dnf upgrade -y
  # Update for pacman (Arch-based systems)
  elif [ "$pm" == "pacman" ]; then
    sudo pacman -Syu --noconfirm
  fi

# Cleanup unnecessary packages
elif [ "$number" == "2" ]; then
  # Cleanup for apt (Ubuntu-based systems)
  if [ "$pm" == "apt" ]; then
    sudo apt autoremove -y && sudo apt clean
  # Cleanup for dnf (Fedora-based systems)
  elif [ "$pm" == "dnf" ]; then
    sudo dnf autoremove -y && sudo dnf clean all
  # Cleanup for pacman (Arch-based systems)
  elif [ "$pm" == "pacman" ]; then
    sudo pacman -Rns $(pacman -Qdtq) --noconfirm
  fi

# Clear the trash
elif [ "$number" == "3" ]; then
  clear_trash

# Exit the script
elif [ "$number" == "4" ]; then
  echo "Exiting..."
  exit 0

# Handle invalid input from the user
else
  echo "Invalid option. Exiting."
  exit 1
fi
