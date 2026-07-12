# Migration: brew CLIs → mise

This document is for machines that already applied the **old** layout (most CLIs via Homebrew, runtimes via mise). New installs can ignore it and just run `chezmoi init --apply`.

## What changed

| Before | After |
|--------|--------|
| Many CLIs on **Homebrew** (`bat`, `fd`, `rg`, `starship`, …) | Same CLIs on **mise** (prefer aqua/github single-binary) |
| `uv` on brew **and** mise | `uv` only via mise |
| `~/.config/mise/config.toml` static (all runtimes always) | Templated from install prompts + `installFlavor` |
| `mise use -g` in a run_once script | Declarative `mise install` from config (run_onchange) |
| `PATH` had `~/.bun/bin` (standalone bun) | bun only via mise |
| Optional `source ~/.cargo/env` | Removed — rust/cargo come from mise when enabled |
| skim key-bindings from brew share path | `sk --shell zsh --shell-bindings` (works with mise) |
| Updates ad hoc | `topgrade` (always via mise, both flavors) |

**Homebrew stays** for:

- bootstrap: `mise`, `antidote`
- system-ish packages (`coreutils`, `trash`, …)
- casks (Ghostty, fonts, gcloud)
- leftovers that are awkward in mise (`aria2` on full flavor)

**mise owns** language toolchains and almost all CLI devtools.

## Prerequisites

- `chezmoi` source already at `~/.local/share/chezmoi` (or your usual path)
- Homebrew + `mise` formula still installed

```bash
command -v brew && command -v mise && command -v chezmoi
```

## Steps (existing machines)

### 1. Pull / apply the new source

```bash
cd "$(chezmoi source-path)"
git pull
chezmoi apply
```

This will:

- write the new `~/.config/mise/config.toml` (templated)
- update zsh files (no bun path, no cargo env, new sk integration, `upd`)
- run `run_onchange_after_10-install-user-prefs` → `mise install -y`
- install light/full CLIs according to your saved `preferences.installFlavor` and `install.*` flags

If apply prompts feel wrong, check:

```bash
chezmoi data | less
# look at .install and .preferences.installFlavor
```

To change flags later you need to edit chezmoi config data (re-run init prompts or edit `~/.config/chezmoi/chezmoi.toml` / re-init carefully).

### 2. Confirm mise tools

```bash
mise ls
mise doctor   # optional
command -v bat fd rg delta starship just atuin sk uv topgrade
command -v eza   # still from brew
# full flavor also:
command -v jq gh dust procs grex hwatch glow
```

Binaries should resolve under mise (shims or `~/.local/share/mise/...`), not only `/opt/homebrew/bin/...`.

### 3. Uninstall duplicate Homebrew formulas

Only after mise tools work. This frees disk and avoids PATH confusion.

```bash
# Everything that moved to mise (light + full). Safe once `mise ls` looks good.
brew uninstall --ignore-dependencies \
  bat fd ripgrep git-delta starship just atuin sk git-lfs \
  rust-parallel uv topgrade \
  jq gh dust procs grex hwatch glow \
  2>/dev/null || true

# diffnav was a tap formula
brew uninstall --ignore-dependencies diffnav 2>/dev/null || true
brew untap dlvhdr/formulae 2>/dev/null || true

# KEEP on brew:
#   mise antidote eza aria2 (full) trash (darwin brew.light, keg-only)
#   coreutils grc pv git (system-ish)
#   casks: ghostty, fonts, gcloud-cli, ...
```

Optional cleanup:

```bash
brew autoremove
brew cleanup
```

### 3b. Topgrade config conflict

If topgrade ever auto-created `~/.config/topgrade.toml`, it **wins** over
`~/.config/topgrade/topgrade.toml`. Chezmoi manages `~/.config/topgrade.toml`.

```bash
# After chezmoi apply, if an old auto-generated file is left unmanaged:
# (only if it is NOT the chezmoi-managed one — check with chezmoi managed)
chezmoi apply ~/.config/topgrade.toml
# remove orphan dir from older layout if present:
rm -rf ~/.config/topgrade
```

### 4. Optional: remove standalone leftovers

```bash
# Old standalone bun install (mise owns bun when install.node is true)
rm -rf "$HOME/.bun"

# Only if you no longer use a separate rustup install:
# rm -rf "$HOME/.cargo" "$HOME/.rustup"
# Prefer: enable install.rust and let mise manage the toolchain.
```

### 5. Reload the shell

```bash
exec zsh -l
# or open a new terminal
```

Check skim integration and prompt:

```bash
type sk
type starship
type topgrade
```

### 6. Ongoing updates

```bash
topgrade            # brew, mise, chezmoi, gh extensions, uv, …
# or partial:
mise upgrade
brew update && brew upgrade
chezmoi update
```

## Flavor matrix (reference)

### Brew (`packages_base.yaml`)

| Flavor | Formulas |
|--------|----------|
| light | `mise`, `antidote` |
| full | light + `aria2` |
| casks (darwin) | Ghostty, Nerd Font, … |

### Mise (`dot_config/mise/config.toml.tmpl`)

| Set | Tools |
|-----|--------|
| always | `python`, `uv`, light CLIs (`bat`, `fd`, `ripgrep`, `delta`, `diffnav`, `starship`, `just`, `git-lfs`, `rust-parallel`, `atuin`, `sk`, `topgrade`) |
| brew light | `mise`, `antidote`, `eza` (eza has no macOS prebuilt via aqua/github) |
| full | `jq`, `gh`, `dust`, `procs`, `grex`, `hwatch`, `glow` |
| `install.node` | `node`, `bun`, `pnpm`, `yarn` |
| `install.rust` | `rust` |
| `install.zig` | `zig` |
| `install.golang` | `go` |
| `install.ruby` / `reactnative` | `ruby` |

## Troubleshooting

### `command not found` after uninstalling brew formulas

```bash
eval "$(brew shellenv)"
eval "$(mise activate zsh)"
mise install -y
hash -r
```

Ensure `~/.zshrc` activates mise **after** `brew shellenv` (current template does).

### mise still lists missing tools (go/ruby/rust)

Those tools are only in config when the matching `install.*` flag is true. Old static config forced them to `latest` even when disabled; the template fixed that. Clear orphans:

```bash
# optional: remove unused installs
mise prune
```

### sk key bindings missing

Need a recent `sk` with `--shell-bindings`:

```bash
sk --help | grep shell-bindings
source <(sk --shell zsh --shell-bindings)
```

### `antidote` errors

Still installed via brew; path is `$(brew --prefix)/opt/antidote/...`. If missing:

```bash
brew install antidote
```

### re-run mise install without waiting for script hash

```bash
mise install -y
```

### chezmoi did not re-run the install script

The script is `run_onchange_after_*` and re-runs when its **rendered** content changes. Force:

```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
# or only re-run by bumping the TOOLS_SNAPSHOT comment in the script and apply
```

## Rollback (emergency)

Reinstall CLIs from brew temporarily:

```bash
brew install bat fd ripgrep git-delta starship eza just atuin sk git-lfs uv
# full:
brew install jq gh dust procs topgrade grex hwatch glow
```

Then restore a previous git revision of the chezmoi source if needed.
