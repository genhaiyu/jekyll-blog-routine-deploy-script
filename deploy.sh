#!/bin/bash

set -e

abort() {
  printf "%s\n" "$@"
  exit 1
}

RV="3.1.0"
T="dnf"
install_commands="yum"
firewall_http="sudo firewall-cmd --permanent --add-service=http"
firewall_https="sudo firewall-cmd --permanent --add-service=https"
firewall_reload="sudo firewall-cmd --reload"

source '/etc/os-release'

check_sys() {
  if [[ "${ID}" = "centos" && "${VERSION_ID}" == 8 ]]; then
    V="C8"
  elif [[ "${ID}" = "centos" && "${VERSION_ID}" == 7 ]]; then
    GPG="gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
    V="C7"
    T="yum"
    #    elif [[ "${ID}" = "ubuntu"  ]]; then

    #  else
    # abort "The script doesn't support the current system!"
  fi
}

OS="$(uname)"
if [[ "${OS}" != "Linux" ]]; then
  abort "The script only support Linux currently."
fi

reload_source() {
  source '/etc/profile.d/rvm.sh'
}

reload_bundle() {
  if [[ -d "./_site" ]]; then
    bundle clean --force
  fi
  rvm use 3.1.0
  bundle install
}

check_dir() {
  if ! [[ -e "Gemfile" ]]; then
    abort "Please build this script in jekyll blog directory!"
  fi
  rm -rf 'Gemfile.lock'
}

check_dir

# Private repositories, username and password required
# git clone https://github.com/genhaiyu/genhaiyu.github.io.git
check_repository_status() {
  read -rp "Do you want to get git repository up to date (y/n)? " update
  case "$update" in
  y | Y)
    git pull
    sleep 2
    ;;
  *)
    echo "User canceled git update, skipping."
    ;;
  esac
}

check_rvm_env() {
  check_sys
  if ! [[ -e "/usr/local/rvm/bin/rvm" ]]; then
    # https://rvm.io/rvm/security#install-our-keys
    if [ "$V" = "C7" ]; then
      $GPG
    else
      gpg2 --keyserver keys.openpgp.org --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    fi
    curl -sSL https://get.rvm.io | bash -s stable
  fi
  reload_source
  if ! [[ -e "/usr/bin/ruby" ]]; then
    # $ rvm list known, depend on Gemfile compatibility
    echo "Start installing ruby, it will take a few minutes."
    # debian 2.7.1
    rvm install 3.1.0
    sleep 3
  fi
  jekyll="/usr/local/rvm/gems/ruby-$RV/bin/jekyll"
  echo "$jekyll"
  if ! [[ -e "${jekyll}" ]]; then
    gem install jekyll bundler
  fi
  reload_bundle
}

check_nginx() {
  if [[ -x "/usr/sbin/nginx" ]]; then
    echo "It is detected that nginx has been installed, skip it."
  else
    # Default nginx version
    if [ $V = "C7" ]; then
      sudo $T install nginx
    else
      sudo $T install nginx
    fi
    sleep 3
    sudo systemctl enable nginx
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
    sudo systemctl start nginx
  fi
  rm -rf /usr/share/nginx/html/*
  # mkdir /html
  # TODO Configure nginx.conf
  mv "_site"/* "/usr/share/nginx/html/"
  chcon -Rt httpd_sys_content_t "/usr/share/nginx/html/"
  sudo systemctl start nginx
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
  echo -e "\033[32mIt will check and install jekyll related dependencies.\033[0m"
  #  cd "$HOME"/"${PWD##*/}" || exit
  check_rvm_env
  check_repository_status
  build_pre
  check_nginx
  echo -e "\033[32mJekyll blog has been successfully deployed!\033[0m"
  # TODO Console :)
}

build_jekyll
