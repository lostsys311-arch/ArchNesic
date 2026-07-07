# Amnesic Wipe — .bashrc
# ephemeral shell with useful defaults

alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias tor-status='systemctl status tor --no-pager'
alias tor-log='journalctl -u tor -n 50 --no-pager'
alias mem-free='free -h'
alias meminfo='cat /proc/meminfo'
alias kernel-params='cat /proc/cmdline'
alias firewall='iptables -L -v -n'

export EDITOR=vim
export SYSTEMD_PAGER=cat
export PAGER=less

# Pretty prompt
PS1='\[\e[1;31m\]⟐\[\e[0m\] \[\e[1;37m\]\u\[\e[0m\]@\[\e[1;31m\]awipe\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\n\[\e[1;31m\]➤\[\e[0m\] '
PS2='\[\e[1;31m\]→\[\e[0m\] '

# MOTD on login
[[ -f /etc/motd ]] && cat /etc/motd
