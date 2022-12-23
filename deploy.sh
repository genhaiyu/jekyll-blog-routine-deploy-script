#!/bin/bash

abort() {
  printf "%s\n" "$@"
  exit 1
}

OS="$(uname)"
if [[ "${OS}" != "Linux" ]]; then
  abort "The script only support Linux currently."
fi

check_dir() {
  if ! [[ -e "Gemfile" ]]; then
    abort "Please build this script in jekyll blog directory!"
  fi
}

check_dir

# Public or private repositories, cd ..
# | git clone https://github.com/genhaiyu/genhaiyu.github.io.git
check_repository_status() {
  git pull
  sleep 1
}

#check_repository_status

check_rvm() {
  if [ -d "/usr/local/rvm/" ] || [ ! -e "/usr/bin/ruby" ]; then
    echo "jekyll env has been install"
    return 1
  else
    # https://rvm.io/rvm/security#install-our-keys
    gpg2 --keyserver keys.openpgp.org --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    sleep 3
  fi
}

last_time_generate() {
  old_site="_site/"
  if [ -d ${old_site} ]; then
    echo "The site generated last time was found."
    rm -rf $old_site
    echo "The site has been deleted."
  fi
}

# Assuming you has been install rvm and ruby env, before operate this function
build_jekyll() {
  echo "It will check ruby and rvm env, and then will install if not install, it will take some time to process."
  #  cd "$HOME"/"${PWD##*/}" || exit
  check_rvm
  sleep 2
  source /etc/profile.d/rvm.sh
  # $ rvm list known, or rvm install 2.7.1
  rvm install 3.0.0
  rvm use 3.0.0
  gem install jekyll bundler
  bundle clean --force
  bundle install
  last_time_generate
  jekyll build --source "$HOME"/"${PWD##*/}"
  sleep 3
  if pgrep -x "nginx"; then
    sudo pkill -9 nginx
    echo "The nginx process has been killed."
  fi
}

build_jekyll
