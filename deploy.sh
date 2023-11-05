#!/bin/bash

set -e

RED='\033[0;31m'
NC='\033[0m'
Blue='\033[0;34m'
Green='\033[0;32m'
ERROR="The script doesn't support the current system!"

abort() {
  printf "${RED}%s${NC}\n" "$@"
  exit 1
}

DEFAULT_STABLE_VERSION="3.1.0"
INSTALL_TYPE="dnf"
# Tested on Ubuntu 20.04 only
UV="20.04"
# Keys reference to https://rvm.io/rvm/security#install-our-keys
RVM_KEYS="--recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"

change_keys() {
  GPG="gpg --keyserver hkp://keyserver.ubuntu.com:80 $RVM_KEYS"
}

compare_version() {
  perl -e "{if($1>=$2){print 1} else {print 0}}"
}

check_sys() {
  OS="$(uname)"
  if ! [[ "${OS}" = "Linux" ]]; then
    abort "$ERROR"
  fi
  if ! [[ $UID == 0 ]]; then
      abort "Try to use root to do the following actions."
  fi
  source '/etc/os-release'
  if [[ "${ID}" = "centos" && "${VERSION_ID}" == 8 ]]; then
    GPG2="gpg2 --keyserver keys.openpgp.org $RVM_KEYS"
  elif [[ "${ID}" = "centos" && "${VERSION_ID}" == 7 ]]; then
    change_keys
    INSTALL_TYPE="yum"
  elif [[ "${ID}" = "ubuntu" ]] && [[ "$(compare_version "${VERSION_ID}" $UV)" == 1 ]]; then
    INSTALL_TYPE="apt-get"
    change_keys
  else
    abort "$ERROR"
  fi
}

reload_bundle() {
  if [[ -d "./_site" ]]; then
    bundle clean --force
  fi
  rvm use $DEFAULT_STABLE_VERSION
  bundle install
}

check_dir() {
  if ! [[ -e "Gemfile" ]]; then
    abort "Please build this script in Jekyll blog directory!"
  fi
  # Always refresh the gem
  rm -rf 'Gemfile.lock'
}

# Private repository, username and password required
pull_repository_data() {
  read -rp "Do you want to keep the Git repository up to date (y/n)? " update
  case "$update" in
  y | Y)
    git pull
    sleep 2
    ;;
  *)
    echo "User canceled Git update, continuing."
    ;;
  esac
}

check_rvm_env() {
  check_dir
  check_sys

  if ! [[ -f "/usr/local/rvm/bin/rvm" ]]; then
    if [[ "$INSTALL_TYPE" = "dnf" || "$INSTALL_TYPE" = "apt-get" ]]; then
      $GPG2
    else
      $GPG
    fi
    curl -sSL https://get.rvm.io | bash -s stable
  fi
  source '/etc/profile.d/rvm.sh'
  if ! [[ -f "/usr/local/rvm/rubies/ruby-$DEFAULT_STABLE_VERSION/bin/ruby" ]]; then
    echo "Start installing Ruby, it may take a few minutes."
    rvm install $DEFAULT_STABLE_VERSION
    sleep 2
  fi

  jekyll_location="/usr/local/rvm/gems/ruby-$DEFAULT_STABLE_VERSION/bin/jekyll"
  if ! [[ -f "$jekyll_location" ]]; then
    gem install jekyll bundler
  fi
  reload_bundle
}

build_posted() {
  if [[ $INSTALL_TYPE = "yum" ]] || [[ $INSTALL_TYPE = "dnf" ]]; then
    rm -rf /usr/share/nginx/html/*
    mv "_site"/* "/usr/share/nginx/html/"
    if [[ $INSTALL_TYPE = 'dnf' ]]; then
      chcon -Rt httpd_sys_content_t "/usr/share/nginx/html/"
    fi
  elif [[ $INSTALL_TYPE = "apt-get" ]]; then
    rm -rf /var/www/html/*
    mv "_site"/* "/var/www/html/"
  else
    abort "$ERROR"
  fi
  sudo systemctl start nginx
}

# curl -4/-6
preview_url() {
  # Internal IP
  # ipv4=$(ip route get 1 | sed 's/^.*src \([^ ]*\).*$/\1/;q')
  external_ipv4=$(curl -4 icanhazip.com)
  preview="http://"$external_ipv4
}

check_nginx() {
  if [[ -f "/usr/sbin/nginx" ]]; then
    echo "Nginx is detected as installed, skip it."
  else
    if [ $INSTALL_TYPE = "yum" ]; then
      sudo $INSTALL_TYPE install nginx
    elif [ $INSTALL_TYPE = "apt-get" ]; then
      sudo $INSTALL_TYPE install nginx
      sudo $INSTALL_TYPE install firewalld
    else
      # dnf
      sudo $INSTALL_TYPE install nginx
    fi
    sleep 2
    sudo systemctl enable nginx
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
    sudo systemctl start nginx
  fi
  build_posted
}

build_pre() {
  rm -rf _site/
  jekyll build --source "$HOME"/"${PWD##*/}"
  sleep 3
  if pgrep -x "nginx" >/dev/null; then
    sudo pkill -9 nginx
  fi
}

build_jekyll() {
  echo -e "${Green}Checking for Jekyll related dependencies.${NC}"
  check_rvm_env
  pull_repository_data
  build_pre
  check_nginx
  preview_url
  echo -e "${Green}==> Jekyll blog has been successfully deployed!${NC}"
  echo -e "${Blue}==> Here is the preview URL (ipv4): ${NC}\e[4m$preview\e[0m"
}

build_jekyll
