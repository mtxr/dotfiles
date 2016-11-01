Workstation
========

Forked and based from [https://github.com/anishathalye/dotfiles].

After cloning this repo, run `git clone https://github.com/mtxr/workstation.git && cd workstation && ./install` to automatically set up the basic workstation

We use [Dotbot][https://github.com/anishathalye/dotbot] for installation.

Making Local Customizations
---------------------------

You can make local customizations for some programs by editing these files:

* `vim` : `~/.vimrc_local`
* `zsh` : `~/.zshrc_local_before` run before `.zshrc`
* `zsh` : `~/.zshrc_local_after` run after `.zshrc`
* `git` : `~/.gitconfig_local`
* `tmux` : `~/.tmux_local.conf`

License
-------

Copyright (c) 2013-2016 Anish Athalye. Released under the MIT License. See
[LICENSE.md][license] for details.

[dotbot]: https://github.com/anishathalye/dotbot
[license]: LICENSE.md
