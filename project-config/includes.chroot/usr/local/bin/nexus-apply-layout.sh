#!/usr/bin/env bash
# ==============================================================================
# The Nexus OS First-Login KDE Plasma 6 Helper Script
# ==============================================================================
set -euo pipefail

readonly STAMP_FILE="${HOME}/.config/nexus-layout-applied"
readonly WALLPAPER_PATH="/usr/share/wallpapers/NexusOS/contents/images/1920x1080.jpg"

if command -v VBoxClient-all >/dev/null 2>&1; then
  VBoxClient-all >/dev/null 2>&1 || true
fi

if [[ -f "${STAMP_FILE}" ]]; then
  exit 0
fi

for _ in $(seq 1 20); do
  if gdbus introspect --session --dest org.kde.PlasmaShell --object-path /PlasmaShell >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

if command -v plasma-apply-desktoptheme >/dev/null 2>&1; then
  plasma-apply-desktoptheme Fluent-round-dark >/dev/null 2>&1 || true
fi
if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
  plasma-apply-colorscheme NexusLightStreaks >/dev/null 2>&1 || true
fi
if command -v plasma-apply-wallpaperimage >/dev/null 2>&1 && [[ -f "${WALLPAPER_PATH}" ]]; then
  plasma-apply-wallpaperimage "${WALLPAPER_PATH}" >/dev/null 2>&1 || true
fi

mkdir -p "$(dirname "${STAMP_FILE}")"
touch "${STAMP_FILE}"
