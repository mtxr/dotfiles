Workstation
========
Just simply run (if zsh and curl is installed, MacOS case):

```shellscript
curl -o /tmp/install https://raw.githubusercontent.com/mtxr/dotfiles/master/install && exec zsh /tmp/install
```

or (wget and bash, most linux distros)

```shellscript
wget -O /tmp/install https://raw.githubusercontent.com/mtxr/dotfiles/master/install && exec bash /tmp/install
```

I use [Homemaker](https://foosoft.net/projects/homemaker) for installation.

Making Local Customizations
---------------------------

You can make local customizations for some programs by editing these files:

* `vim` : `~/.vimrc_local`
* `git` : `~/.gitconfig_local`

License
-------

Copyright (c) 2013-2016 Anish Athalye. Released under the MIT License. See [LICENSE.md](LICENSE.md) for details.

* [Homemaker](https://foosoft.net/projects/homemaker): https://foosoft.net/projects/homemaker
