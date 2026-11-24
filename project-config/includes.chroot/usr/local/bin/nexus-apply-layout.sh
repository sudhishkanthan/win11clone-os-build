#!/usr/bin/env bash
# ==============================================================================
# The Nexus OS First-Login KDE Plasma 6 Layout Script
# Configures:
#   1. Sleek top bar (Application Launcher, Center Date & Time, System Tray)
#   2. Centered floating bottom dock (Dolphin, Firefox, Konsole, Kate, Settings, Workspace Pager)
#   3. The Nexus OS Alpine Lake Reflection wallpaper
# ==============================================================================
set -euo pipefail

readonly STAMP_FILE="${HOME}/.config/nexus-layout-applied"
readonly WALLPAPER_PATH="/usr/share/wallpapers/NexusOS/contents/images/1920x1080.jpg"

# Ensure VirtualBox Guest Additions X11 client daemons are active
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
// Remove default panels for clean deterministic layout
var existingPanels = panels();
for (var i = 0; i < existingPanels.length; i++) {
    existingPanels[i].remove();
}

// 1. TOP PANEL: Frosted glass status bar
var topPanel = new Panel();
topPanel.location = "top";
topPanel.height = 32;
topPanel.floating = false;

// Top-left: Application launcher
var kickoff = topPanel.addWidget("org.kde.plasma.kickoff");
kickoff.currentConfigGroup = ["General"];
kickoff.writeConfig("icon", "start-here-kde");
kickoff.writeConfig("favoritesPortedToKAstats", "true");

// Center spacing
topPanel.addWidget("org.kde.plasma.panelspacer");

// Top-center: Date & Clock
var topClock = topPanel.addWidget("org.kde.plasma.digitalclock");
topClock.currentConfigGroup = ["Appearance"];
topClock.writeConfig("showDate", "true");
topClock.writeConfig("dateFormat", "shortDate");

// Right spacing
topPanel.addWidget("org.kde.plasma.panelspacer");

// Top-right: System Tray
topPanel.addWidget("org.kde.plasma.systemtray");

// 2. BOTTOM PANEL: Centered Floating Dock
var dock = new Panel();
dock.location = "bottom";
dock.height = 56;
dock.floating = true;
dock.alignment = "center";

// Dock pinned apps (Icon-Only Task Manager)
var tasks = dock.addWidget("org.kde.plasma.icontasks");
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

// Virtual Desktops Pager inside dock
dock.addWidget("org.kde.plasma.pager");

// Show desktop button at edge of dock
dock.addWidget("org.kde.plasma.showdesktop");

// 3. Set Alpine Lake Reflection wallpaper on all desktops
var allDesktops = desktops();
for (var j = 0; j < allDesktops.length; j++) {
    var d = allDesktops[j];
    d.wallpaperPlugin = "org.kde.image";
    d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    d.writeConfig("Image", "file:///usr/share/wallpapers/NexusOS/contents/images/1920x1080.jpg");
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
