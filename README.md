# Automatically deploy and release a jekyll blog

[![GNU General Public License v3.0](https://img.shields.io/github/license/genhaiyu/jekyll-blog-routine-deploy-script)](https://github.com/genhaiyu/jekyll-blog-routine-deploy-script/blob/master/LICENSE)
[![](https://img.shields.io/github/actions/workflow/status/genhaiyu/jekyll-blog-routine-deploy-script/check-build.yml)](https://github.com/genhaiyu/jekyll-blog-routine-deploy-script/blob/master/.github/workflows/check-build.yml)

> Streamlining the steps of deploy a jekyll blog requires manual input of many commands after cutting off nginx traffic and processes.

<img src="https://user-images.githubusercontent.com/17850202/222082624-4703c0bb-4812-4954-becf-90b67453e6d6.gif" width="500" alt="example"/>

## Documentation

Download the script in blog directory where deployed on Linux, make sure the directory should have the `Gemfile`, which mean it is in the correct directory. This [A sample of Jekyll blog](https://github.com/genhaiyu/jekyll-example) passed built test, can be release a blog quickly.
```markdown
curl -sSLO https://raw.githubusercontent.com/genhaiyu/jekyll-blog-routine-deploy-script/master/deploy.sh && chmod a+x deploy.sh && bash deploy.sh
```

The script automatically installs `rvm`, `ruby`, `nginx` these dependencies on the new server, otherwise it will only be updated, built, deploy, released routinely.

Currently supported Linux systems: `Ubuntu 20.04 LTS x64`, `CentOS 8 Stream x64`, `CentOS 7 x64`

## Issues

This script convenient for my routine deployment of `jekyll` blog.
