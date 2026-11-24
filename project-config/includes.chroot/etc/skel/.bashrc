
# The Nexus OS Neofetch Banner on Terminal Start
if [ -n "$PS1" ] && [ -z "$NEXUS_GREETED" ]; then
    export NEXUS_GREETED=1
    echo -e "       \033[38;2;40;180;255mNN     NN\033[0m   \033[1;36mnexus@the-nexus-os\033[0m"
    echo -e "      \033[38;2;50;150;255mNNN    NN\033[0m   ------------------"
    echo -e "     \033[38;2;70;120;255mNNNN   NN\033[0m   \033[1;37mOS:\033[0m The Nexus OS 1.0 (Debian 13)"
    echo -e "    \033[38;2;90;90;255mNN NN  NN\033[0m   \033[1;37mKernel:\033[0m 6.12.0-nexus-amd64"
    echo -e "   \033[38;2;120;70;255mNN  NN NN\033[0m   \033[1;37mShell:\033[0m bash 5.2.32"
    echo -e "  \033[38;2;150;50;255mNN   NNNN\033[0m   \033[1;37mTheme:\033[0m Nexus Glass Dark [Teal]"
    echo -e " \033[38;2;180;40;255mNN    NNN\033[0m   \033[1;37mIcons:\033[0m Nexus 2.5D + White Symbolic"
    echo -e "\033[38;2;210;30;255mNN     NN\033[0m   \033[1;37mFont:\033[0m SF Display (11pt)"
    echo -e "             \033[48;2;0;210;255m   \033[48;2;0;140;255m   \033[48;2;30;220;120m   \033[48;2;255;170;0m   \033[48;2;255;60;100m   \033[48;2;170;60;255m   \033[0m\n"
fi
