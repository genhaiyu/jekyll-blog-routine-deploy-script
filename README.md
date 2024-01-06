# A script to automatically deploy a Jekyll blog on Linux

<p quote align="center">
<img src="https://user-images.githubusercontent.com/17850202/264347872-8fd87cae-80dd-4721-b60a-dbc4578eadfc.png" width="260" alt="octojekyll" style="align: center"></p>

[![](https://img.shields.io/github/actions/workflow/status/genhaiyu/jekyll-blog-routine-deploy-script/check-build.yml)](https://github.com/genhaiyu/jekyll-blog-routine-deploy-script/blob/master/.github/workflows/check-build.yml)
> After each commit to repository (including private GitHub Pages repository), go to the server to execute this script,
> which can automatically deploy and release a Jekyll blog.

<p quote align="center">
<img src="https://user-images.githubusercontent.com/17850202/265168014-41ed930f-dd74-4783-8104-c55f638b8338.gif" width="560" alt="deploying"/></p>

## Documentation

The script automatically checks and installs the dependencies of the Jekyll prerequisite environment on a new server,
includes `RVM`, `Ruby`, `Nginx`.
Otherwise, it only updates, builds, deploys from repository.

- Quick steps:
    * Copy the `A sample of Jekyll blog` repository to a server, or choose your preferred Jekyll.
        * This [A sample of Jekyll blog](https://github.com/genhaiyu/jekyll-example) is a Jekyll skeleton for releases
          an example quickly purpose.
    * Enter the repository directory on the server, build this script to automatically initial or routine update.

```markdown
curl -sSLO https://raw.githubusercontent.com/genhaiyu/jekyll-blog-routine-deploy-script/master/deploy.sh && chmod a+x
deploy.sh && bash deploy.sh
```

Currently supported Linux systems: `Ubuntu 20.04, 22.04.2 LTS, 23.04 x86/64`, `CentOS 7, Stream 8 x86/64`.

If running a site on CentOS 7/8, should disable SELINUX setting in `/etc/selinux/config` file.
If not, the page will give `403 Forbidden` error even you have done another way.

```markdown
sudo vim /etc/selinux/config
```

Update `SELINUX=enforcing` to `SELINUX=disabled` in `/etc/selinux/config` file, then reboot the system.

[Full documentation](https://genhai.dev/customize-a-jekyll-blog-to-automatically-deploy-and-release-on-linux.html) for
this script.

## License

[![GNU General Public License v3.0](https://img.shields.io/github/license/genhaiyu/jekyll-blog-routine-deploy-script)](https://github.com/genhaiyu/jekyll-blog-routine-deploy-script/blob/master/LICENSE)
