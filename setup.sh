#!/usr/bin/env bash
#
# Bootstrap script for github.com/rth1894/arch-dwm-st-nvim
# Sets up: dwm (6.5, patched) + st + dwmbar (suckless), zsh + zinit + p10k,
# ghostty, nvim (lazy.nvim config), fonts, picom/xcompmgr, clipmenu, feh.
#
# Usage:
#   ./setup.sh
#
# Run as a normal (non-root) user with sudo privileges. Do NOT run as root.

set -uo pipefail

REPO_URL="https://github.com/rth1894/arch-dwm-st-nvim.git"
REPO_DIR="${HOME}/arch-dwm-st-nvim"
LOG="${HOME}/dotfiles-setup.log"

c_red()   { printf '\033[1;31m%s\033[0m\n' "$*"; }
c_green() { printf '\033[1;32m%s\033[0m\n' "$*"; }
c_blue()  { printf '\033[1;34m%s\033[0m\n' "$*"; }

step() { echo; c_blue "==> $*"; }
warn() { c_red "!! $*"; }
ok()   { c_green "   $*"; }

run() {
    # run a command, log it, don't kill the whole script if it fails
    echo "+ $*" >>"$LOG"
    if ! "$@" >>"$LOG" 2>&1; then
        warn "Command failed (see $LOG): $*"
        return 1
    fi
}

# ---------------------------------------------------------------------------
# 0. Sanity checks
# ---------------------------------------------------------------------------

if [[ $EUID -eq 0 ]]; then
    c_red "Don't run this as root. Run it as your normal user; it will sudo when needed."
    exit 1
fi

if ! command -v pacman &>/dev/null; then
    c_red "This doesn't look like Arch Linux (no pacman found). Aborting."
    exit 1
fi

sudo -v || { c_red "Need sudo access to continue."; exit 1; }
# keep sudo alive for the duration of the script
( while true; do sudo -n true; sleep 60; done ) 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

: >"$LOG"
step "Logging verbose output to $LOG"

# ---------------------------------------------------------------------------
# 1. Packages
# ---------------------------------------------------------------------------

step "Updating system"
sudo pacman -Syu --noconfirm

step "Installing core + build packages"
CORE_PKGS=(
    base-devel git curl wget unzip pkgconf
    xorg-server xorg-xinit xorg-xrdb xorg-xmodmap xorg-xsetroot xorg-xrandr
    libx11 libxft libxinerama freetype2 fontconfig
)
sudo pacman -S --needed --noconfirm "${CORE_PKGS[@]}"

step "Installing WM/terminal/desktop utilities"
DESKTOP_PKGS=(
    zsh ghostty picom xcompmgr feh clipmenu
    networkmanager pipewire pipewire-pulse pipewire-alsa wireplumber
    noto-fonts noto-fonts-emoji ttf-dejavu
)
sudo pacman -S --needed --noconfirm "${DESKTOP_PKGS[@]}"

step "Installing CLI tools used by .zshrc/.bashrc aliases"
CLI_PKGS=(neovim fzf ripgrep bat eza fd)
sudo pacman -S --needed --noconfirm "${CLI_PKGS[@]}"

step "Installing Neovim LSP/formatter runtime deps (mason needs these)"
LSP_RUNTIME_PKGS=(nodejs npm python python-pip)
sudo pacman -S --needed --noconfirm "${LSP_RUNTIME_PKGS[@]}"

step "Installing neofetch (best-effort, package is unmaintained upstream)"
if ! sudo pacman -S --needed --noconfirm neofetch; then
    warn "neofetch unavailable via pacman, trying fastfetch instead"
    sudo pacman -S --needed --noconfirm fastfetch || warn "Skipping neofetch/fastfetch"
fi

# ---------------------------------------------------------------------------
# 2. Get the dotfiles repo
# ---------------------------------------------------------------------------

step "Fetching dotfiles"
if [[ -d "${REPO_DIR}/.git" ]]; then
    ok "Repo already present at $REPO_DIR, pulling latest"
    git -C "$REPO_DIR" pull
elif [[ -f "./README.md" && -d "./suckless" && -d "./zsh" ]]; then
    ok "Looks like this script is already sitting inside the repo, using $(pwd)"
    REPO_DIR="$(pwd)"
else
    git clone "$REPO_URL" "$REPO_DIR"
fi
cd "$REPO_DIR"

backup() {
    # backup $1 to $1.bak-<timestamp> if it exists and isn't a symlink to us
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        mv "$target" "${target}.bak-$(date +%Y%m%d%H%M%S)"
    fi
}

# ---------------------------------------------------------------------------
# 3. Build & install dwm, st, dwmbar
# ---------------------------------------------------------------------------

step "Building & installing dwm (patched 6.5)"
(
    cd "$REPO_DIR/suckless/dwm-6.5"
    sudo make clean install
) && ok "dwm installed" || warn "dwm build/install failed, check $LOG"

step "Building & installing st"
(
    cd "$REPO_DIR/suckless/st"
    sudo make clean install
) && ok "st installed" || warn "st build/install failed, check $LOG"

step "Installing dwmbar"
(
    cd "$REPO_DIR/suckless/dwmbar"
    chmod +x dwmbar install.sh uninstall.sh bar.sh modules/* 2>/dev/null || true
    sudo ./install.sh
) && ok "dwmbar installed to /usr/bin/dwmbar" || warn "dwmbar install failed, check $LOG"

# copy default dwmbar config to the user's home config dir (what dwmbar -c does)
mkdir -p "$HOME/.config/dwmbar/custom"
cp -f "$REPO_DIR/suckless/dwmbar/config" "$HOME/.config/dwmbar/config"

# ---------------------------------------------------------------------------
# 4. Fonts
# ---------------------------------------------------------------------------

step "Installing bundled Nerd Fonts"
mkdir -p "$HOME/.local/share/fonts"
cp -f "$REPO_DIR"/fonts/* "$HOME/.local/share/fonts/"
fc-cache -f >>"$LOG" 2>&1
ok "Fonts installed and cache rebuilt"

# ---------------------------------------------------------------------------
# 5. Dotfiles: zsh, xinit, ghostty, nvim, neofetch
# ---------------------------------------------------------------------------

step "Installing zsh config (current, not the legacy bash/ one)"
backup "$HOME/.zshrc"
cp -f "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"

step "Installing .xinitrc"
backup "$HOME/.xinitrc"
cp -f "$REPO_DIR/zsh/.xinitrc" "$HOME/.xinitrc"
chmod +x "$HOME/.xinitrc"

step "Installing ghostty config"
mkdir -p "$HOME/.config/ghostty"
cp -f "$REPO_DIR/ghostty/config" "$HOME/.config/ghostty/config"

step "Installing nvim config (nvim/ lazy.nvim setup, not the legacy root init.lua)"
backup "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim"
cp -r "$REPO_DIR/nvim/." "$HOME/.config/nvim/"

step "Installing neofetch config"
mkdir -p "$HOME/.config/neofetch"
cp -f "$REPO_DIR/neofetch/config.conf" "$HOME/.config/neofetch/config.conf" 2>/dev/null || true

step "Setting up picom config dir"
mkdir -p "$HOME/.config/picom"
if [[ ! -f "$HOME/.config/picom/picom.conf" ]]; then
    warn "No picom.conf shipped in the repo — .xinitrc points to ~/.config/picom/picom.conf"
    warn "picom will fall back to its built-in defaults until you add one."
fi

step "Copying wallpapers referenced by .xinitrc"
cp -f "$REPO_DIR/images/adam.png"     "$HOME/adam.png"     2>/dev/null || true
cp -f "$REPO_DIR/images/wall2_1.png"  "$HOME/wall2_1.png"  2>/dev/null || true
cp -f "$REPO_DIR/images/wall.jpg"     "$HOME/wall.jpg"     2>/dev/null || true

# stub out ~/.local/bin/check_aur.sh, which .xinitrc backgrounds but which
# isn't part of the repo, so it doesn't matter functionally either way
mkdir -p "$HOME/.local/bin"
if [[ ! -f "$HOME/.local/bin/check_aur.sh" ]]; then
    cat >"$HOME/.local/bin/check_aur.sh" <<'EOF'
#!/bin/sh
# placeholder — .xinitrc calls this on login; replace with your own AUR
# update-checker if you want one.
exit 0
EOF
    chmod +x "$HOME/.local/bin/check_aur.sh"
fi

# ---------------------------------------------------------------------------
# 6. Shell + services
# ---------------------------------------------------------------------------

step "Setting zsh as default shell"
if [[ "$SHELL" != *zsh ]]; then
    sudo chsh -s "$(command -v zsh)" "$USER" && ok "Default shell set to zsh (takes effect on next login)"
fi

step "Enabling NetworkManager"
sudo systemctl enable --now NetworkManager >>"$LOG" 2>&1 || warn "Could not enable NetworkManager"

step "Enabling pipewire user services"
systemctl --user enable --now pipewire pipewire-pulse wireplumber >>"$LOG" 2>&1 \
    || warn "Could not enable pipewire user services (fine if this is a chroot/container)"

# ---------------------------------------------------------------------------
# 7. Auto-start X on tty1 login
# ---------------------------------------------------------------------------

step "Wiring up startx-on-login for tty1"
ZPROFILE="$HOME/.zprofile"
if ! grep -q "exec startx" "$ZPROFILE" 2>/dev/null; then
    cat >>"$ZPROFILE" <<'EOF'

# Auto-start X (dwm) on first virtual terminal login
if [[ -z "$DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
    exec startx
fi
EOF
    ok "Added auto-startx block to ~/.zprofile"
else
    ok "~/.zprofile already has a startx block"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

step "Done"
cat <<EOF

$(c_green "Setup finished.") Full log: $LOG

What happened:
  - dwm, st, dwmbar built from suckless/ and installed system-wide
  - Nerd Fonts copied to ~/.local/share/fonts
  - ~/.zshrc, ~/.xinitrc, ~/.config/ghostty/config, ~/.config/nvim,
    ~/.config/neofetch/config.conf installed from the repo
  - zsh set as your default shell
  - tty1 login will auto-run startx -> dwm

Still manual:
  - No picom.conf ships in the repo, so drop your own at
    ~/.config/picom/picom.conf if you want custom compositor settings
    (otherwise picom just uses its defaults).
  - zinit + powerlevel10k + all zsh plugins bootstrap themselves the
    first time you open a zsh shell (needs internet on first launch).
  - lazy.nvim bootstraps itself and installs all plugins + LSPs/
    formatters (via mason) the first time you run 'nvim' (needs internet).
  - Log out and back in on tty1 (or reboot) to get zsh + auto-startx.

EOF
