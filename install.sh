#!/usr/bin/env bash

# Turn off cursor.
setterm -cursor off

banner () {
clear
echo "                             ";
echo " Fast and beautiful!         ";
echo "  - By @HitaloSama on GitHub ";
echo "                             ";
}
banner

# Handy function to silence stuff.
shutt () {
    { "$@" || return $?; } | while read -r line; do
        :
    done
}

# Get fastest mirrors.
echo -n -e " -> Syncing with fastest mirrors. \033[0K\r"
(pkg update -y 2>/dev/null) | while read -r line; do
    :
done
sleep 2

# Upgrade packages.
echo -n -e " -> Upgrading packages. \033[0K\r"
pkg upgrade -y 2>/dev/null
pkg install python -y && pip install pip wheel setuptools lolcat -U 2>/dev/null
sleep 2

# LOL
echo " "
echo "Wait... This isn't as beautiful as it should!!!"
echo " "
sleep 3

banner () {
clear
echo "                             " | lolcat -a;
echo " Fast and beautiful!         " | lolcat -a;
echo "  - By @HitaloSama on GitHub " | lolcat -a;
echo "                             " | lolcat -a;
}
banner

# Updating package repositories and installing packages.
echo -n -e " -> Installing required packages. \033[0K\r" | lolcat -a
shutt apt update &>/dev/null
shutt pkg install -y curl git zsh man 2>/dev/null
sleep 2

# Installing SUDO.
echo -n -e " -> Installing SUDO. \033[0K\r" | lolcat -a
pkg install tsu -y &>/dev/null
sleep 2

# Giving Storage permision to Termux App.
if [ ! -d ~/storage ]; then
    echo -n -e " -> Setting up storage access for Termux. \033[0K\r" | lolcat -a
    termux-setup-storage
    sleep 2
fi

# Installing ZInit.
echo -n -e " -> Installing ZInit framework for ZSH. \033[0K\r" | lolcat -a
(echo 'Y' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)") &> /dev/null
sleep 2

# Changing default shell to ZSH.
echo -n -e " -> Changing default shell to ZSH. \033[0K\r" | lolcat -a
chsh -s zsh
sleep 2

# Importing some libs from Oh-My-ZSH
echo -n -e " -> Importing some libs from Oh-My-ZSH. \033[0K\r" | lolcat -a
cat <<'EOF' >> ~/.zshrc

# Loading some(?) Oh-My-ZSH libs with ZInit Turbo!
zinit lucid light-mode for \
    OMZ::lib/history.zsh \
    OMZ::lib/completion.zsh \
    OMZ::lib/key-bindings.zsh
EOF
sleep 2

# Addons for ZInit.
echo -n -e " -> Setting up ZInit addons. \033[0K\r" | lolcat -a
cat <<'EOF' >> ~/.zshrc

# Syntax highlighting, completions, auto-suggestions and some other plugins.
zinit wait lucid light-mode for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
      zdharma/fast-syntax-highlighting \
      OMZ::plugins/colored-man-pages \
      OMZ::plugins/git \
  atload"!_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions
EOF
sleep 2

# Installing powerlevel10k theme for ZSH.
echo -n -e " -> Setting up powerlevel10k theme. \033[0K\r" | lolcat -a
cat <<'EOF' >> ~/.zshrc

# Powerlevel10k Theme.
zinit ice depth=1; zinit light romkatv/powerlevel10k
EOF
sleep 2

# Installing the Powerline font for Termux.
if [ ! -f ~/.termux/font.ttf ]; then
    echo -n -e " -> Installing Powerline patched font. \033[0K\r" | lolcat -a
    curl -fsSL -o ~/.termux/font.ttf 'https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf'
    sleep 2
fi

# Add new buttons to the Termux bottom bar.
echo -n -e " -> Setting up some extra keys in Termux. \033[0K\r" | lolcat -a
curl -fsSL -o ~/.termux/termux.properties 'https://raw.githubusercontent.com/HitaloSama/Hitmux/master/.termux/termux.properties'
sleep 2

# Reload Termux settings.
termux-reload-settings

# Run a ZSH shell, opens the p10k config wizard.
banner
echo -n -e " -> Installation complete, gimme cookies! \033[0K\r" | lolcat -a
sleep 3

# Restore cursor
setterm -cursor on

if ! grep -lq "zsh" "$SHELL"; then
    clear
    exec zsh -l
fi
exit
exit