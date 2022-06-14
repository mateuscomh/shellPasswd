#!/usr/bin/env bash

#------------------------------------------------------------------------------|
# AUTOR             : Matheus Martins <3mhenrique@gmail.com>
# HOMEPAGE          : https://github.com/mateuscomh
# DATA/VER.         : 29/08/2020 2.1
# LICENÇA           : GPL3
# PEQUENA-DESCRICÃO : Shell Script to generate fast passwords on terminal
# REQUISITOS        : xclip on GNU/Linux / pbcopy on MacOS

#------------------------------------------------------------------------------|
export LANG=C
FECHA='\033[m'
VERDE='\033[32;1m'
VERMELHO='\033[31;1m'
AMARELO='\033[01;33m'
MAX=$1
#----------FUNC-------------------------------------------------------------|

_gerarsenha(){
if [ -z "$MAX" ] || [ "$MAX" -eq 0 ]; then
  echo -e "${VERDE} Enter the QUANTITY of characters for the password: ${FECHA}"
  read -r MAX
fi

case $MAX in
  ''|*[!0-9]*)
    echo -e "${VERMELHO} Enter only numbers referring to the SIZE of the password ${FECHA}"
    return 1
    ;;
  [0-9]*)
    echo -e "${VERDE} Enter the TYPE of password complexity you want: ${FECHA}
    ${AMARELO} 1 - Password only numbers ${FECHA}
    ${AMARELO} 2 - Password with LeTtErS and numb3rs ${FECHA}
    ${AMARELO} 3 - Password with LeTtErS, numb3rs and Speci@l Ch@r@ct&rs ${FECHA}"
    read -r TIPO

  case "$TIPO" in
    ''|*[!0-9]*)
      echo -e "${VERMELHO} Enter only numbers referring to the TYPE of the password ${FECHA}"
      return 2
      ;;
    1)
      PASS=$(cat /dev/urandom LC_ALL=C | tr -dc '0-9' | head -c "$MAX")
      command -v xclip > /dev/null && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy
      echo -e "${VERDE}$PASS${FECHA}"
      ;;
    2)
      PASS=$(cat /dev/urandom LC_ALL=C | tr -dc 'A-Za-z0-9' | head -c "$MAX")
      command -v xclip > /dev/null && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy
      echo -e "${VERDE}$PASS${FECHA}"
      ;;
    3)
      PASS=$(cat /dev/urandom LC_ALL=C |
        tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c "$MAX")
      command -v xclip > /dev/null && echo -n "$PASS" | xclip -sel copy || echo -n "$PASS" | pbcopy
      echo -e "${VERDE}$PASS${FECHA}"
      ;;
    *)
      echo -e "${VERMELHO} Use only the options [1,2,3] ${FECHA}"
      return 1
      ;;
  esac
esac
}
#---------MAIN-------------------------------------------------------------------|
case "$MAX" in
  -h | --help )
    echo -e "${VERDE} Program to generate complex passwords
      alphanumeric and with special characters quickly via terminal ${FECHA}"
    echo -e "${VERDE} Author mateuscomh vulgo Django ${FECHA}"
    exit 0
    ;;
  -v | --version )
    echo -e "${VERDE} Versão 2.1 ${FECHA}"
    exit 0
    ;;
  '')
    OP=s
    while true; do
      if [[ "$OP" = [yYsS] ]]; then
        MAX=0
      _gerarsenha
        read -n 1 -p "Do you want to generate new password? [Y/n]" OP; echo
      elif [[ "$OP" = [nN] ]]; then
        break
      else
        echo -e "${VERMELHO} Invalid option ${FECHA}"
        read -n 1 -p "Do you want to generate new password? [Y/n]" OP; echo
      fi
    done
    ;;
  [0-9]*)
    _gerarsenha
    ;;
esac
