#!/usr/bin/env bash
# ==============================================================================
# Win11Clone-OS First-Login KDE Plasma 6 Layout Script
# Applies a centered floating bottom taskbar (Start, Search, Pinned Apps, Tray)
# and default Fluent wallpaper once per user profile.
# ==============================================================================
set -euo pipefail

readonly STAMP_FILE="${HOME}/.config/win11-layout-applied"
readonly WALLPAPER_PATH="/usr/share/wallpapers/Win11Clone/contents/images/1920x1080.svg"

# Ensure VirtualBox Guest Additions X11 client daemons are active when inside VirtualBox
if command -v VBoxClient-all >/dev/null 2>&1; then
  VBoxClient-all >/dev/null 2>&1 || true
fi

# Run layout initialization only once per user so manual tweaks are preserved
if [[ -f "${STAMP_FILE}" ]]; then
  exit 0
fi

# Wait up to 30 seconds for PlasmaShell D-Bus interface to become available
for _ in $(seq 1 30); do
  if gdbus introspect --session --dest org.kde.PlasmaShell --object-path /PlasmaShell >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

read -r -d '' PLASMA_SCRIPT <<'EOF' || true
// Remove existing default panels for a deterministic layout
var existingPanels = panels();
for (var i = 0; i < existingPanels.length; i++) {
    existingPanels[i].remove();
}

// Create Windows 11-style floating bottom taskbar
var panel = new Panel();
panel.location = "bottom";
panel.height = 48;
panel.floating = true;
panel.alignment = "center";

// Left expanding spacer to center Start + Search + Task Manager
panel.addWidget("org.kde.plasma.panelspacer");

// Start menu (Kickoff)
var kickoff = panel.addWidget("org.kde.plasma.kickoff");
kickoff.currentConfigGroup = ["General"];
kickoff.writeConfig("icon", "start-here-kde");
kickoff.writeConfig("favoritesPortedToKAstats", "true");

// Search trigger (KRunner / Application Search)
var search = panel.addWidget("org.kde.plasma.kickerdash");
search.currentConfigGroup = ["General"];
search.writeConfig("icon", "edit-find");

// Centered pinned apps (Icon-Only Task Manager)
var tasks = panel.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "preferred://filemanager",
    "preferred://browser",
    "applications:org.kde.kate.desktop",
    "applications:org.kde.konsole.desktop",
    "applications:org.kde.kcalc.desktop",
    "applications:systemsettings.desktop"
].join(","));
tasks.writeConfig("indicateAudioStreams", "true");

// Right expanding spacer to pin system tray & clock to bottom-right
panel.addWidget("org.kde.plasma.panelspacer");

// System Tray, Digital Clock, and Show Desktop button
panel.addWidget("org.kde.plasma.systemtray");

var clock = panel.addWidget("org.kde.plasma.digitalclock");
clock.currentConfigGroup = ["Appearance"];
clock.writeConfig("showDate", "true");
clock.writeConfig("dateFormat", "shortDate");

panel.addWidget("org.kde.plasma.showdesktop");

// Apply Win11Clone Fluent wallpaper to all desktops
var allDesktops = desktops();
for (var j = 0; j < allDesktops.length; j++) {
    var d = allDesktops[j];
    d.wallpaperPlugin = "org.kde.image";
    d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    d.writeConfig("Image", "file:///usr/share/wallpapers/Win11Clone/contents/images/1920x1080.svg");
}
EOF

gdbus call \
  --session \
  --dest org.kde.PlasmaShell \
  --object-path /PlasmaShell \
  --method org.kde.PlasmaShell.evaluateScript \
  "${PLASMA_SCRIPT}" >/dev/null

mkdir -p "$(dirname "${STAMP_FILE}")"
touch "${STAMP_FILE}"
