# M1 Mini Inventory — Part 1 prep

Snapshot taken 2026-09-21 for the [clean install runbook](mac-clean-install-runbook.md). This repo is public: no secrets, project names, or `.env` paths belong in here.

## Homebrew: requested on the M1 vs. the repo

Sources: `brew bundle dump`, `brew leaves --installed-on-request`, and the Cellar install receipts (`installed_on_request`). The receipts list is the widest — it includes things requested once that other formulae now also depend on — so it is the one sorted below. Everything under "build deps" is absent from `brew leaves`, which confirms that verdict.

~100 formulae were explicitly installed that the Brewfiles don't carry. Sorted into a proposed verdict — **nothing from this list has been added except `figlet`**. Promote by editing the right `Brewfile.<tag>`; everything else is pruned by omission.

**Worth keeping (candidates)**

| Formula | Suggested layer |
|---|---|
| `figlet` | base — added (bootstrap installs fonts for it) |
| `tldr`, `trash`, `tmux`, `moreutils`, `p7zip`, `xz`, `pigz`, `ssh-copy-id`, `ast-grep`, `uv` | base |
| `gnupg`, `pinentry` | base, only if you start signing commits (no secret keys exist today) |
| `sass`, `woff2`, `sfnt2woff`, `sfnt2woff-zopfli`, `zopfli`, `pngcheck`, `folderify` | personal (web/font tooling; two need third-party taps) |
| `openai-whisper`, `ghostscript`, `xpdf` | desktop |
| `go`, `lua`, `himalaya`, `rtk`, `certbot`, `dnsmasq`, `mysql-client`, `libpq` | decide per tool — install on demand |

**Probably prune**

- Security/CTF tooling: `hydra`, `john`, `sqlmap`, `nmap`, `hashpump`, `fcrackzip`, `foremost`, `knock`, `dns2tcp`, `tcpflow`, `socat`, `cifer`, `dex2jar`, `vbindiff`, `binutils`
- EOL runtimes: `php@7.3`, `php@7.4`, `node@14`, `python@3.9`, `python@3.10`, `mysql@8.4` (duplicate of `mysql`)
- Apache: `httpd` (nginx/Herd/Valet cover this)
- Build deps recorded as "requested" but really dependencies: `autoconf`, `automake`, `libtool`, `pkgconf`, `nasm`, `gmp`, `glib`, `gd`, `libpng`, `libssh`, `libssh2`, `libfido2`, `gnutls`, `nghttp2`, `p11-kit`, `unbound`, `ldns`, `unixodbc`, `freetds`, `tcl-tk`, `guile`, `augeas`, `netpbm`, `cffi`, `pycparser`, `perl`, `dpkg`, `ucspi-tcp`
- Misc: `ack` (ripgrep), `screen` (tmux), `lynx`, `rlwrap`, `bash`, `bash-completion@2`, `bfg`, `comby`, `fastmod`

**In the repo but never explicitly installed here** (arrived as dependencies): `curl`, `gnu-tar`, `imagemagick`, `openssl`, `php`, `webp`. Harmless; kept.

**In the repo but not installed on the M1 at all:** `wget`, `optipng`, `redis`. You have gone without them here, which makes them prune candidates — though `wget` has its own stow package (`.wgetrc`), so either keep both or drop both.

**Staleness:** 173 installed formulae are outdated, so `./bundle.sh check` fails on this machine for version reasons, not missing packages. Irrelevant to the new builds; `brew upgrade` if you want a clean check here.

**Open question — `node` and `yarn` in the base Brewfile.** Volta manages Node on this machine and wins on `PATH`. The Homebrew copies are redundant; dropping them (and adding Volta's installer to the runbook) would remove a source of "which node is this" confusion.

### Casks

Installed: `1password-cli`, `dockdoor`, `dotnet-sdk`, `fig`, `font-monaspace`, `font-monaspace-nf`, `ghostty`, `raycast`, `repobar`, `tailscale-app`, `vagrant`, `warp`.

Carried forward: `font-monaspace-nf` (base); `1password-cli`, `raycast`, `tailscale-app` (personal). The rest are left for install-on-demand. `fig` is discontinued — prune.

### Taps

`shivammathur/php` (old PHP), `bramstein/webfonttools`, `sass/sass`, `dart-lang/dart`, `oven-sh/bun`, `steipete/tap`, `yakitrak/yakitrak`, `antoniorodr/memo`, `homebrew/services`. None are needed by the current Brewfiles.

## Outside Homebrew

**Composer global:** `laravel/installer`, `laravel/valet`, `laravel/vapor-cli`.

**npm global:** nothing beyond npm/corepack — globals live in Volta.

**Volta:** default `node@22`, `npm@11`, `yarn@1.22`. Global packages: `@usebruno/cli`, `gitmoji-cli`, `@tobilu/qmd`, `sass-migrator`, `@imarc/ops` (pinned to node 12 — likely dead). Eight older Node runtimes are cached; they re-download on demand, so none need carrying over.

**Per-project versions:** only one project declares a Node version (`.node-version`); none declare PHP. Worth fixing in the project repos before the rebuild.

**VS Code:** 115 extensions, saved to [`setup/vscode-extensions.txt`](../setup/vscode-extensions.txt). Restore with `xargs -n1 code --install-extension < setup/vscode-extensions.txt` — or prune the list first; 115 is a lot.

**`~/Library/LaunchAgents`** (14): Setapp ×4, iStat Menus ×2, Adobe ×2, Dropbox updater, iMazing Mini, MailSteward schedule, CodeWhisperer launcher, OpenClaw gateway, Homebrew dnsmasq. All are recreated by their apps on install — **copy none**. The two to consciously re-set-up if still wanted: the dnsmasq service and the MailSteward schedule.

**`~/Library/Fonts`:** 443 files. Too many to carry blind — copy the families you actually use, or sync via a font manager.

## Secrets & signing (facts only)

- `.env` files exist across the product repos and their worktrees, including encrypted variants. Most encrypted envs are committed with their repos; the plaintext ones are what need a transfer plan.
- `~/.aws` contains only SSO config — no long-lived credentials file. Re-run `aws configure sso` per machine.
- No GPG secret keys; commit signing is off. Nothing to export.
- One valid code-signing identity in the login keychain — export as `.p12`.
- SSH keys live in the 1Password agent, not on disk, so nothing to copy. Per-machine keys (runbook recommendation) means creating a new 1Password SSH key item per machine rather than sharing the current one.
