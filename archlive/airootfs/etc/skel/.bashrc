# ArchNesic (v3) — .bashrc
# ephemeral shell with useful defaults

alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias tor-status='systemctl status tor --no-pager'
alias tor-log='journalctl -u tor -n 50 --no-pager'
alias tor-nyx='nyx'
alias mem-free='free -h'
alias meminfo='cat /proc/meminfo'
alias kernel-params='cat /proc/cmdline'
alias firewall='iptables -L -v -n; iptables -t nat -L -v -n'
alias killswitch='sudo /usr/local/bin/killswitch'
alias onion-address='cat /var/lib/tor/ssh_hidden_service/hostname 2>/dev/null'
alias lock='swaylock'
alias unsafe='sudo /usr/local/bin/unsafe-browser'
alias panic='sudo /usr/local/bin/panic-overlay.sh'
alias watchdog-status='systemctl status tor-watchdog.timer --no-pager'
alias tor-test='curl --socks5 127.0.0.1:9050 -s https://check.torproject.org/api/ip | head -c 200'

export EDITOR=vim
export SYSTEMD_PAGER=cat
export PAGER=less
export BROWSER=/usr/bin/firefox

# Pretty prompt with dynamic hostname
PS1='\[\e[1;31m\]⟐\[\e[0m\] \[\e[1;37m\]\u\[\e[0m\]@\[\e[1;31m\]\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\n\[\e[1;31m\]➤\[\e[0m\] '
PS2='\[\e[1;31m\]→\[\e[0m\] '

# MOTD on login
[[ -f /etc/motd ]] && cat /etc/motd
fastfetch
