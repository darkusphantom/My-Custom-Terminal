#!/bin/bash

# Verify if wget exist and install it
installWget() {
  verifyWget=$(which wget)
  if [[ $? -eq 1 ]]; then
    echo "Installing wget..."
    read -s -p "Write your password: " passwordSudo
    echo "$passwordSudo" | sudo -S apt update
    echo "$passwordSudo" | sudo -S apt -y install wget
  fi
}

installOhMyZSH() {
  echo "Installing ohmyzsh"
  installWget
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  echo "Oh-my-zsh installed"
  sleep 3
}

installZSH(){
  echo "Verify if it is install zsh..."
  verifyZsh=$(which zsh)

  if [[ $? -eq 1 ]]; then
    echo "ZSH is not install. Now is installing..."
    read -s -p "Write your password: " passwordSudo
    echo "$passwordSudo" | sudo -S apt update
    echo "$passwordSudo" | sudo -S apt -y install zsh
    echo "ZSH installed"
  else
    echo "ZSH was installed"
  fi
  sleep 2
  
  echo "Changing to ZSH"
  chsh -s $(which zsh)
  sleep 3

  installOhMyZSH
}

installThemePowerLevel() {
  echo "Installing theme powerlevel..."
  read -s -p "Write your password: " passwordSudo
  echo "$passwordSudo" | sudo -S apt update
  echo "$passwordSudo" | sudo -S apt -y install fonts-powerline

  echo "Installing fonts..."
  installWget
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  mkdir MesloLGS
  mv *.ttf MesloLGS
  sudo mv MesloLGS /usr/share/fonts/MesloLGS

  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  textReplace=\"robbyrussell\"
  isTextReplace=`less ~/.zshrc | grep $textReplace`

  if $isTextReplace -ne "powerlevel10k/powerlevel10k"; then
    sed -i 's/"robbyrussell"/"powerlevel10k\/powerlevel10k"/g' ~/.zshrc
  fi

  echo "Successful install"
  sleep 2

  zsh
}

installPlugins() {
  echo "Installing plugins..."
  sleep 2

  #Plugins ZSH Syntax
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  #Plugins ZSH sugestion
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  #Plugins alias ZSH
  git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips

  echo "Plugins installed"
  sleep 3
}

customTerminal() {
  echo "Installing customTerminal..."
  sleep 2

  dirZsh=$HOME/.config/zsh

  git clone https://github.com/darkusphantom/My-Custom-Terminal.git
  mv My-Custom-Terminal $dirZsh
  ln -s $HOME/.config/zsh/.zshrc $HOME/.zshrc

  #installThemePowerLevel
  installPlugins

  echo "Custom terminal instalation completed"
  sleep 3
}

# Execution
option=0
while :; do
  clear
  echo "Instalación de la terminal con ZSH y Oh-my-zsh"
  echo "What do you want to do?"
  echo "--------------------------------"
  echo "1. Install ZSH and Oh-my-zsh"
  echo "2. Install theme powerlevel"
  echo "3. Install plugins"
  echo "4. Exit"
  read -p "Option: " option

  case $option in
    1 ) installZSH ;;
    2 ) #installThemePowerLevel
      echo "No disponible aun"
    ;;
    3 ) #installPlugins
      echo "No disponible aun"
      ;;
    4 )
      customTerminal
      ;;
    5 )
      echo "Finish program... Thank you"
      echo "Don't forgot follow me in social media how @darkusphantom or @darkusphxntxm"
      sleep 3
      exit
  esac
done
