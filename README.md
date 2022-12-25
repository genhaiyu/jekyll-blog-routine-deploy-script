# jekyll-blog-routine-deploy-script

> Streamlining the steps of deploy a jekyll blog requires manual input of many commands after cutting off nginx traffic and processes


## Documentation

Download the script in your blog directory, make sure the dir should have the `Gemfile`, which mean it is in the correct directory. 
```markdown
wget -N --no-check-certificate -q -O deploy.sh "https://raw.githubusercontent.com/genhaiyu/jekyll-blog-routine-deploy-script/master/deploy.sh" && chmod +x deploy.sh && bash deploy.sh
```

`rvm`, `ruby`, `nginx` will be automatically installed via script on the new server where the blog is deployed.


## License

[![GNU General Public License v3.0](https://img.shields.io/github/license/genhaiyu/jekyll-blog-routine-deploy-script)](https://github.com/genhaiyu/jekyll-blog-routine-deploy-script/blob/master/LICENSE)
