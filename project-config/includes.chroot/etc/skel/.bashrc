# ~/.bashrc: The Nexus OS Interactive Shell Configuration
[ -z "$PS1" ] && return

export PS1='\[\e[1;32m\]\u@the-nexus-os\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias grep='grep --color=auto'

neofetch() {
    echo ""
    echo -e "  \e[38;5;33m███\e[38;5;69m╗   \e[38;5;208m██\e[38;5;202m╗\e[0m    \e[1;38;5;75mnexus@the-nexus-os\e[0m"
    echo -e "  \e[38;5;33m████\e[38;5;69m╗  \e[38;5;208m██\e[38;5;202m║\e[0m    \e[38;5;242m───────────────────────────\e[0m"
    echo -e "  \e[38;5;33m██\e[38;5;69m╔██\e[38;5;135m╗ \e[38;5;208m██\e[38;5;202m║\e[0m    \e[1;38;5;75mOS:\e[0m     The Nexus OS 1.0 (Debian 13)"
    echo -e "  \e[38;5;33m██\e[38;5;99m║╚██\e[38;5;171m╗\e[38;5;208m██\e[38;5;202m║\e[0m    \e[1;38;5;75mKernel:\e[0m $(uname -r)"
    echo -e "  \e[38;5;33m██\e[38;5;99m║ ╚████\e[38;5;202m║\e[0m    \e[1;38;5;75mTheme:\e[0m  Light Streaks • Frosted Header"
    echo -e "  \e[38;5;33m╚═╝  ╚═══╝\e[0m    \e[1;38;5;75mIcons:\e[0m  Nexus 2.5D + White Symbolic"
    echo -e "                \e[1;38;5;75mFont:\e[0m   SF Pro Display"
    echo ""
}

if [[ $- == *i* ]]; then
    neofetch
fi
