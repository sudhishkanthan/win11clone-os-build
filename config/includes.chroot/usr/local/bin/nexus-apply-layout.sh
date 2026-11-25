#!/bin/bash
FLAG="$HOME/.config/.nexus_layout_applied"
[ -f "$FLAG" ] && exit 0
sleep 3
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat /usr/share/nexus-os/plasma-layout.js)" || true
touch "$FLAG"
