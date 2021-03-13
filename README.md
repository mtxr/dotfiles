# Workstation

With curl:

```shellscript
curl -sfL https://git.io/.mtxr | sh
```

With wget:

```shellscript
wget -O - https://git.io/.mtxr | sh
```

Note: I use [chezmoi](https://https://www.chezmoi.io/docs/) for dotfiles management.

## Making Local Customizations

You can make local customizations for some programs by editing these files:

- `git` : `~/.gitconfig_local`
