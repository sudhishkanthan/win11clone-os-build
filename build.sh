#!/usr/bin/env bash
# ==============================================================================
# Win11Clone-OS ISO Build Script (Debian 13 "Trixie" / KDE Plasma 6 / Calamares)
# Target: x86_64 (amd64) hybrid ISO with Legacy BIOS + UEFI boot support
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

readonly OS_NAME="Win11Clone-OS"
readonly DISTRO_CODENAME="trixie"
readonly ARCH="amd64"
readonly MIRROR_URL="${MIRROR_URL:-http://deb.debian.org/debian/}"
readonly SECURITY_MIRROR_URL="${SECURITY_MIRROR_URL:-http://security.debian.org/debian-security}"

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_CONFIG_DIR="${SCRIPT_DIR}/project-config"
readonly BUILD_DIR="${SCRIPT_DIR}/build"
readonly OUT_DIR="${SCRIPT_DIR}/out"
readonly ISO_OUT="${OUT_DIR}/${OS_NAME}.iso"

log() {
  printf '[%s] [INFO] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

die() {
  printf '[%s] [ERROR] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >&2
  exit 1
}

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    die "This script must be run as root (use: sudo ./build.sh)."
  fi
}

check_host_environment() {
  if [[ ! -d "${PROJECT_CONFIG_DIR}" ]]; then
    die "Missing project-config directory at ${PROJECT_CONFIG_DIR}."
  fi

  if grep -qi microsoft /proc/version 2>/dev/null; then
    log "WSL2 environment detected. Ensure this project resides on the native Linux filesystem (e.g., ~/win11clone-os-build), NOT /mnt/c/."
    if [[ "${SCRIPT_DIR}" == /mnt/* ]]; then
      die "Cannot build on Windows-mounted filesystem (${SCRIPT_DIR}). Copy project to ~/win11clone-os-build and re-run."
    fi
  fi
}

install_host_dependencies() {
  log "Installing host build dependencies..."
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq
  apt-get install -y --no-install-recommends \
    live-build \
    debootstrap \
    debian-archive-keyring \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-common \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    dosfstools \
    ca-certificates \
    curl

  # Ensure debootstrap has the trixie script when running on Ubuntu hosts/CI runners
  if [[ ! -e "/usr/share/debootstrap/scripts/${DISTRO_CODENAME}" ]] && [[ -e /usr/share/debootstrap/scripts/sid ]]; then
    ln -s sid "/usr/share/debootstrap/scripts/${DISTRO_CODENAME}"
  fi
}

configure_live_build() {
  log "Preparing clean live-build workspace at ${BUILD_DIR}..."
  mkdir -p "${BUILD_DIR}" "${OUT_DIR}"
  cd "${BUILD_DIR}"

  if [[ -d "${BUILD_DIR}/config" ]]; then
    lb clean --purge
    rm -rf "${BUILD_DIR}/config"
  fi

  log "Running lb config for Debian ${DISTRO_CODENAME} (${ARCH}, BIOS + UEFI)..."
  lb config \
    --mode debian \
    --system live \
    --distribution "${DISTRO_CODENAME}" \
    --architectures "${ARCH}" \
    --archive-areas "main contrib non-free non-free-firmware" \
    --mirror-bootstrap "${MIRROR_URL}" \
    --mirror-chroot "${MIRROR_URL}" \
    --mirror-chroot-security "${SECURITY_MIRROR_URL}" \
    --mirror-binary "${MIRROR_URL}" \
    --mirror-binary-security "${SECURITY_MIRROR_URL}" \
    --binary-images iso-hybrid \
    --bootloaders "syslinux,grub-efi" \
    --debian-installer none \
    --apt-recommends false \
    --apt-indices true \
    --cache true \
    --chroot-filesystem squashfs \
    --iso-application "${OS_NAME}" \
    --iso-publisher "Win11Clone-OS Project" \
    --iso-volume "WIN11CLONE_OS" \
    --bootappend-live "boot=live components quiet splash locales=en_US.UTF-8 keyboard-layouts=us username=live user-fullname=Win11Clone"

  log "Syncing project-config (package lists, chroot hooks, /etc/skel, overlays)..."
  cp -a "${PROJECT_CONFIG_DIR}/." "${BUILD_DIR}/config/"

  chmod +x "${BUILD_DIR}"/config/hooks/normal/*.hook.chroot
  chmod +x "${BUILD_DIR}"/config/includes.chroot/usr/local/bin/win11-apply-layout.sh
}

run_build() {
  cd "${BUILD_DIR}"
  log "Starting live-build ISO compilation (this typically takes 15-30 minutes)..."
  lb build 2>&1 | tee "${OUT_DIR}/build.log"

  local generated_iso
  generated_iso="$(find "${BUILD_DIR}" -maxdepth 1 -type f -name '*.hybrid.iso' | head -n 1 || true)"
  if [[ -z "${generated_iso}" || ! -f "${generated_iso}" ]]; then
    die "Build finished without producing a .hybrid.iso file. Check ${OUT_DIR}/build.log."
  fi

  mv -f "${generated_iso}" "${ISO_OUT}"
  sha256sum "${ISO_OUT}" > "${ISO_OUT}.sha256"

  log "Build complete!"
  log "ISO image : ${ISO_OUT}"
  log "Checksum  : ${ISO_OUT}.sha256"
}

main() {
  require_root
  check_host_environment
  install_host_dependencies
  configure_live_build
  run_build
}

main "$@"
