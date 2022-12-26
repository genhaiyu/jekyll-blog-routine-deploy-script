#!/bin/bash

abort() {
  printf "%s\n" "$@"
  exit 1
}

OS="$(uname)"
if [[ "${OS}" != "Linux" ]]; then
  abort "The script only support Linux currently."
fi

reload_source() {
  source '/etc/profile.d/rvm.sh'
}

check_dir() {
  if ! [[ -e "Gemfile" ]]; then
    rm -rf 'Gemfile.lock'
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
  if [[ -d "/usr/local/rvm/" ]]; then
    echo "RVM has been installed."
  else
    # https://rvm.io/rvm/security#install-our-keys
    gpg2 --keyserver keys.openpgp.org --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
  fi
  reload_source
  if [[ -e "/usr/bin/ruby" ]]; then
    echo "Ruby has been installed."
  else
    # $ rvm list known, depend on Gemfile compatibility
    echo "Start installing ruby, it will take a few minutes."
    rvm install ruby-3.0.0
    rvm use 3.0.0
  fi
  jekyll="/usr/local/rvm/gems/ruby-3.0.0/bin/jekyll"
  if [[ -e "${jekyll}" ]]; then
    echo "Jekyll has been installed."
  else
    gem install jekyll bundler
    bundle clean --force
    bundle install
  fi
}

check_nginx() {
  if [[ -x "/usr/sbin/nginx" ]]; then
    echo "Nginx has been installed."
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
  mv "_site"/* "/usr/share/nginx/html/"
  chcon -Rt httpd_sys_content_t "/usr/share/nginx/html/"
  sudo systemctl start nginx
}

build_jekyll() {
  echo "It will check ruby and rvm env, and then will install if not install."
  echo "It will take some time to process."
  #  cd "$HOME"/"${PWD##*/}" || exit
  check_rvm_env
  sleep 2
  rm -rf "_site/"
  reload_source
  jekyll build --source "$HOME"/"${PWD##*/}"
  sleep 3
  if pgrep -x "nginx"; then
    sudo pkill -9 nginx
    echo "The nginx process has been killed."
  fi
  check_nginx
  echo "Jekyll blog has been deployed!"
}

build_jekyll
