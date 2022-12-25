#!/bin/bash

abort() {
  printf "%s\n" "$@"
  exit 1
}

Green="\033[32m"
Black="\033[0m"

OS="$(uname)"
if [[ "${OS}" != "Linux" ]]; then
  abort "The script only support Linux currently."
fi

check_dir() {
  if ! [[ -e "Gemfile" ]]; then
    rm -rf Gemfile.lock
    abort "Please build this script in jekyll blog directory!"
  fi
}

check_dir

# Private repositories, username and password required
# git clone https://github.com/genhaiyu/genhaiyu.github.io.git
check_repository_status() {
  git pull
  sleep 2
}

check_rvm_env() {
  if [ -d "/usr/local/rvm/" ]; then
    echo -e "${Green} rvm has been installed. ${Green}"
  else
    # https://rvm.io/rvm/security#install-our-keys
    gpg2 --keyserver keys.openpgp.org --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
  fi
  if [ -e "/usr/bin/ruby" ]; then
    echo -e "${Green} ruby has been installed. ${Green}"
  else
    # $ rvm list known, depend on Gemfile compatibility
    echo -e "${Green} Start installing ruby, it will take a few minutes. ${Green}"
    rvm install 3.0.0
    sleep 2
  fi
  jekyll="/usr/local/rvm/gems/ruby-3.0.0/bin/jekyll"
  if [ -e "$jekyll" ]; then
    echo -e "${Green} jekyll has been installed. ${Green}"
  else
    gem install jekyll bundler
  fi
  source /etc/profile.d/rvm.sh
  rvm use 3.0.0
}

check_nginx() {
  if [ -x "/usr/sbin/nginx" ]; then
    echo -e "${Green} Nginx has been installed. ${Green}"
  else
    sudo dnf install nginx
    sleep 4
    sudo systemctl enable nginx
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
    sudo systemctl start nginx
  fi
  rm -rf "/usr/share/nginx/html/*"
  mv "_site/*" /usr/share/nginx/html/
  chcon -Rt httpd_sys_content_t /usr/share/nginx/html/
  sudo systemctl start nginx
}

build_jekyll() {
  echo -e "${Green} It will check ruby and rvm env, and then will install if not install. ${Green}"
  echo -e "${Green} It will take some time to process. ${Green}"
  #  cd "$HOME"/"${PWD##*/}" || exit
  check_rvm_env
  sleep 2
  rm -rf "_site/"
  jekyll build --source "$HOME"/"${PWD##*/}"
  sleep 3
  if pgrep -x "nginx"; then
    sudo pkill -9 nginx
    echo -e "${Green} The nginx process has been killed. ${Green}"
  fi
  check_nginx
  echo -e "${Green} Jekyll blog has been deployed! ${Green}"
}

build_jekyll
