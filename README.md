# Automatically deploy and release a jekyll blog

> Streamlining the steps of deploy a jekyll blog requires manual input of many commands after cutting off nginx traffic and processes.


## Documentation

Download the script in blog directory where deployed on Linux, make sure the dir should have the `Gemfile`, which mean it is in the correct directory, see more details `Gemfile.example`
```markdown
wget -N --no-check-certificate -q -O deploy.sh "https://raw.githubusercontent.com/genhaiyu/jekyll-blog-routine-deploy-script/master/deploy.sh" && chmod +x deploy.sh && bash deploy.sh
```

The script automatically installs `rvm`, `ruby`, `nginx` these dependencies on the new server, otherwise it will only be updated, built, deploy, released routinely.

Currently supported Linux systems: `Ubuntu 20.04 LTS x64`, `CentOS 8 Stream x64`, `CentOS 7 x64`

## Issues

This script convenient for my routine deployment of `jekyll` blog, if you have questions please let me know. 

## License

[![GNU General Public License v3.0](https://img.shields.io/github/license/genhaiyu/jekyll-blog-routine-deploy-script)](https://github.com/genhaiyu/jekyll-blog-routine-deploy-script/blob/master/LICENSE)
