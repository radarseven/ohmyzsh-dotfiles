# Clean Install Runbook — M5 Pro MacBook Pro + M6 Mac Mini

**Approach:** Clean install on both. No Migration Assistant. The M1 Mini stays alive indefinitely as a second machine.

**Sequencing:** MBP arrives first and serves as the rehearsal. Every gap in the dotfiles repo surfaces there, gets fixed, and gets committed — so the Mini build runs a tested path instead of a hopeful one. Budget more time for the MBP than it seems to need, and less for the Mini than you'd expect.

---

## Part 1 — Shared prep

Do all of this once, on the M1, before the MBP arrives.

### Make the dotfiles repo machine-aware

Four machines will share this repo — new MBP, new Mini, work MBP, M1 Mini. Restructure before the first build, not after.

Branch on **composable role tags**, not hostnames. Hostname branching creates a chicken-and-egg problem (the repo has to know a machine's name before that machine can bootstrap), breaks silently when macOS appends `-2` on a name collision, and can't express the two axes you actually have.

```
Brewfile              # shared base — everything, everywhere
Brewfile.laptop       # battery, Touch ID, portable tooling
Brewfile.desktop      # heavier tooling, VMs, media apps
Brewfile.personal     # product repos, deploy credentials, personal licenses
Brewfile.work         # work-managed machine only
```

Declare the tags in an **untracked local file**, seeded from hostname at bootstrap but confirmed by you:

```bash
# ~/.config/dotfiles/profile  →  e.g. "laptop personal"

PROFILE="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/profile"
[[ -f "$PROFILE" ]] || bootstrap_prompt_for_profile

read -r -a TAGS < "$PROFILE"
brew bundle --file="$DOTFILES/Brewfile"
for tag in "${TAGS[@]}"; do
  f="$DOTFILES/Brewfile.$tag"
  [[ -f "$f" ]] && brew bundle --file="$f"
done
```

A new machine needs one local line and no repo edit. Renaming a Mac changes nothing. `laptop + work` composes without a dedicated branch.

Apply the same tag layering to shell config, git config, and any machine-varying dotfile — not just Brewfiles.

**The work MBP is the reason this matters.** Personal deploy credentials, AWS config, and product repos should never land on a company-managed machine by default. Keep them behind the `personal` tag and the boundary enforces itself.

- [x] Repo restructured for tag-based multi-machine config — `lib/profile.zsh`, `bundle.sh`, `Brewfile.<tag>`, `~/.mix-tags.d/`, `~/.gitconfig.d/`, `~/.ssh/config.d/`
- [x] `personal`-tagged content audited — PHP/Laravel stack, personal git email, and personal SSH hosts moved out of the shared base
- [ ] `brew bundle dump --force` on the M1, diffed against the repo, and **pruned** — this is the highest-leverage half hour in the whole process. Diff and proposed verdicts are in [m1-inventory.md](m1-inventory.md); the keep/prune calls are yours.
- [ ] `brew leaves --installed-on-request` reviewed: what did you actually ask for, vs. what came along as a dependency (also in the inventory)
- [ ] Pruned result committed

### Inventory what isn't in the repo

Results for the checked items are in [m1-inventory.md](m1-inventory.md).

- [x] `composer global show` — global Composer packages
- [ ] Node/PHP versions per project — if these aren't already declared in a version manager config, commit that now
- [x] `npm ls -g --depth=0` (and `volta list all` — that's where the globals actually live)
- [x] VS Code extensions (`code --list-extensions`) or enable Settings Sync — saved to `setup/vscode-extensions.txt`
- [x] `~/Library/LaunchAgents` — list, audit, copy **selectively**. Prime cruft territory. Verdict: copy none.
- [ ] `~/Library/Fonts`
- [ ] Terminal profiles, if not already in the repo
- [ ] Screenshots of any System Settings panes you've meaningfully customized

### Secrets, credentials, signing

This is the part with no shortcuts.

- [ ] **`.env` files.** By definition these aren't in git, and you'll need them on both machines. Walk every project repo and inventory them. Worth considering whether this rebuild is the moment they move behind a secrets manager instead of being recreated twice by hand.
- [ ] `~/.aws/credentials` and any deploy/CLI auth tokens
- [ ] **TOTP recovery** — confirm your 2FA seeds are recoverable independent of any single machine. Lowest probability of being a problem, worst outcome if it is.
- [ ] Password manager emergency kit accessible offline
- [ ] Developer certificates: export from Keychain Access as `.p12` (Login keychain → My Certificates → Export). iCloud Keychain does **not** carry these.
- [ ] GPG keys if you sign commits — `gpg --export-secret-keys --armor <KEY_ID> > key.asc`, transfer, delete the file
- [ ] `~/.ssh/config`

**SSH keys:** generate fresh per-machine ed25519 keys rather than copying. With three machines live at once you want per-machine revocation and clear attribution in audit logs. Register each separately with your git hosts and deploy targets.

**Local TLS certificates:** regenerate on each machine, don't copy. They're cheap to recreate and copied ones cause confusing trust failures.

### Licenses — sort this now, not mid-build

Adobe CC allows **two** activations. M1 Mini + MBP + M6 Mini is three. Decide which two hold the seats before you're staring at an activation error at an inconvenient moment. Microsoft 365 allows five, so no action there. Any single-seat indie apps need deactivating on the M1 first.

### Databases, VMs, and local services

Default position: **rebuild rather than migrate.** Re-run migrations, re-seed. A clean local environment is one of the bigger wins available here, and if your migrations can't reconstruct a local database, that's worth discovering now rather than later.

Where the data genuinely matters, `pg_dump`/`mysqldump` to a file — don't copy data directories between machines.

VMs belong on the Mini, not the MBP. If they're large, consider leaving them on the M1 permanently; a second desktop is a fine home for them.

### Media

- [ ] Open Photos on the M1 and confirm the library has **fully uploaded**. Don't assume — check the status at the bottom of the Library view.
- [ ] Note the library size; it determines the Photos strategy per machine (below)
- [ ] Fresh Time Machine backup of the M1, completed and spot-checked by actually browsing it

---

## Part 2 — Common build

Identical on both machines. The MBP run is where you find the rough edges.

### Setup Assistant

- [ ] At the Migration Assistant prompt, choose **"Not Now"**
- [ ] **Match your existing short username exactly.** Run `whoami` on the M1 first. Mismatched `/Users/` paths will surface as small annoyances for weeks.
- [ ] Set a distinct computer name and local hostname. Three Macs on one network makes naming collisions genuinely confusing — and if the new Mini is meant to inherit the M1's name, rename the M1 *first* so the handoff is clean.
- [ ] Sign in to iCloud
- [ ] Enable FileVault; save the recovery key somewhere outside all three Macs
- [ ] Run Software Update to completion before installing anything else

### Foundation

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

git clone <dotfiles-repo> ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh    # asks for the profile, stows packages, wires tag layers
./bundle.sh       # Brewfile + Brewfile.<tag> for each tag
```

Answer the profile prompt — it writes `~/.config/dotfiles/profile` (`laptop personal` for the MBP, `desktop personal` for the Mini). The bootstrap should layer the right Brewfiles and configs from there. If it doesn't, fix it here and commit — this is exactly the class of gap the MBP run exists to catch.

Rosetta 2 is only worth installing if you hit an actual Intel binary. Apple has signalled it's winding down, so treat anything requiring it as a prompt to find a replacement rather than a thing to accommodate.

### Dev environment

- [ ] PHP toolchain and per-project versions
- [ ] Composer + global packages
- [ ] Node version manager + required versions
- [ ] Local dev server / site directories re-registered
- [ ] Trusted local TLS certs regenerated
- [ ] Claude Code installed and authenticated; `~/.claude` config, MCP server definitions, and per-project `CLAUDE.md` files in place (these belong in the dotfiles repo if they aren't already)
- [ ] SSH keys generated and registered
- [ ] Clone working repos, restore `.env` files, verify a project boots end-to-end **before** moving on

That last check is the real acceptance test. Don't declare a machine done until something actually runs.

### System Settings pass

Work through deliberately rather than reacting to annoyances later:

- [ ] Finder: sidebar, show extensions, default view, path bar
- [ ] Dock: size, position, auto-hide, strip the defaults
- [ ] Keyboard: key repeat rate, modifier remaps, text replacements
- [ ] Trackpad/mouse
- [ ] Sharing: Remote Login if you SSH in; note the new hostname
- [ ] Time Machine destination

### Reinstall on demand

The discipline that makes a clean install worth doing: **install apps at the moment you first reach for them.** Anything still uninstalled after a month was something you didn't need.

---

## Part 3 — MacBook Pro only

### Portable-specific setup

- [ ] Touch ID enrollment
- [ ] Touch ID for `sudo` — add `auth sufficient pam_tid.so` to `/etc/pam.d/sudo_local` (survives OS updates, unlike editing `sudo` directly)
- [ ] **Find My enabled and verified.** This is the machine that leaves the house; FileVault stops being hygiene and becomes load-bearing.
- [ ] Optimized Battery Charging
- [ ] Low Power Mode behavior on battery vs. power
- [ ] Clamshell and external display arrangement, if it docks anywhere
- [ ] Wake-on-lid, hot corners, and screen-lock timing — tighter defaults than a desktop warrants

### Keep it lean

- Photos: **Optimize Mac Storage**
- No VMs, no large media libraries, no sample archives
- Local databases only for projects you actively develop on the road

### Rehearsal discipline

Every time you have to go hunting on the M1 for something during this build, that's a gap in the repo. Fix it and commit **before** continuing — not at the end, when you've forgotten the context. This is the single behavior that makes the Mini build fast.

- [ ] Repo committed with every gap found during the MBP build

---

## Part 4 — M6 Mac Mini only

By now the path is tested. This build should be substantially faster.

- [ ] Photos: **Download Originals** if the library fits comfortably in 1TB; Optimize if not
- [ ] Large media, samples, and archives land here
- [ ] VMs and heavier local services live here
- [ ] `Brewfile.desktop` extras: anything you deliberately kept off the laptop

### Transferring the large stuff

With both Minis on hand, a direct Thunderbolt cable is the fastest path. macOS brings up a Thunderbolt Bridge interface automatically:

```bash
rsync -avh --progress /source/media/ user@old-mini.local:/path/
```

Resist bulk-copying `~/Library`. That's the cruft you're trying to leave behind.

---

## Part 5 — After both

- [ ] First full Time Machine backup completed on each machine
- [ ] Photos finished initial sync on both; library sizes are what you expect
- [ ] `~/Library/LaunchAgents` nearly empty on both — if it's filling up, something is installing background agents you didn't ask for
- [ ] Every config change made during either build is committed to the dotfiles repo
- [ ] Machine-aware bootstrap verified by re-running it on both

### Giving the M1 a job

An idle third Mac drifts into being a machine you're vaguely afraid to touch. Pick a role deliberately: always-on host for local services and scheduled jobs, Time Machine destination, VM host, or a test environment you don't mind breaking.

Once both new machines are confirmed good, the M1 is free to be wiped and rebuilt for that purpose — a third clean install, this time from a runbook you've now run cx