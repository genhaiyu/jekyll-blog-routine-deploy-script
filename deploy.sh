#!/bin/bash

# 1: Check nginx on serve, if not install, install nginx, mv -f nginx.conf replace default conf
# 2:

abort() {
  printf "%s\n" "$@"
  exit 1
}

last_time_generate() {
  local old_site="_site/"
  if [ -d ${old_site} ]; then
    echo -e "\e[31mThe site generated last time was found.\e[0m"
    rm -rf $old_site
  fi
}

OS="$(uname)"
if [[ "${OS}" != "Linux" ]]; then
  abort "The script only support Linux currently."
fi

check_dir() {
  if ! [[ -e "Gemfile" ]]; then
      abort "Please build the script in jekyll directory!"
  fi
}
check_dir
last_time_generate
# public or private repositories, cd .. | git clone https://github.com/genhaiyu/genhaiyu.github.io.git
check_repository_status() {
  # private repository
  git pull
  sleep 1
}
check_repository_status

# Assuming you has been install rvm and ruby env, before operate this function
build_jekyll() {
  local_folder="${PWD##*/}"
  # Default home directory
  jekyll build --source /root/"${local_folder}"
  sleep 5

}

