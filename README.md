# A script to automatically deploy the Jekyll blog on Linux

<img src="https://user-images.githubusercontent.com/17850202/264347872-8fd87cae-80dd-4721-b60a-dbc4578eadfc.png" width="260" alt="octojekyll">

[![](https://img.shields.io/github/actions/workflow/status/genhaiyu/jekyll-blog-routine-deploy-script/check-build.yml)](https://github.com/genhaiyu/jekyll-blog-routine-deploy-script/blob/master/.github/workflows/check-build.yml)
> After each commit to repository (including private GitHub Pages repository), go to the server to execute this script, which can automatically deploy and release a Jekyll blog.

<img src="https://user-images.githubusercontent.com/17850202/265168014-41ed930f-dd74-4783-8104-c55f638b8338.gif" width="560" alt="deploying"/>

## Documentation

The script automatically checks and installs the dependencies of the Jekyll prerequisite environment on the new server,
such as `RVM`, `Ruby`, `Nginx`.
Otherwise, it only updates, builds, deploys, releases after each commit to GitHub.

- Quick steps:
  * Copy the `A sample of Jekyll blog` repository below to a Linux server.
    * This [A sample of Jekyll blog](https://github.com/genhaiyu/jekyll-example) is a basic Jekyll skeleton, can be released an example quickly.
  * Go to the repository directory on the server, execute the command of below after changing the current user is root.

```markdown
curl -sSLO https://raw.githubusercontent.com/genhaiyu/jekyll-blog-routine-deploy-script/master/deploy.sh && chmod a+x deploy.sh && bash deploy.sh
```

Currently supported Linux systems: `CentOS 7 x86/64`(recommend), `Ubuntu 20.04 LTS x86/64`, `CentOS 8 Stream x86/64`.

## License

[![GNU General Public License v3.0](https://img.shields.io/github/license/genhaiyu/jekyll-blog-routine-deploy-script)](https://github.com/genhaiyu/jekyll-blog-routine-deploy-script/blob/master/LICENSE)
