#!/bin/bash

# 1: Check nginx on serve, if not install, install nginx, mv -f nginx.conf replace default conf
# 2:

abort() {
  printf "%s\n" "$@"
  exit 1
}

last_time_generate() {
local _site="_site/"
  if [ -d "$_site" ]; then
      echo -e "\e[31mThe site generated last time was found, it will be delete.\e[0m"
  fi
}

OS="$(uname)"
if [[ "${OS}" != "Linux" ]]
then
  abort "The script only support Linux currently."
fi

read -rp "Please type your xx:" folder_name
echo "$folder_name"

last_time_generate
