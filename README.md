# Win11Clone-OS Build Project

A deterministic, reproducible Debian 13 (`trixie`) `live-build` project that compiles a bootable `x86_64` hybrid ISO (`Win11Clone-OS.iso`) with Legacy BIOS and UEFI support, minimal KDE Plasma 6 styled after Windows 11, pre-installed VirtualBox Guest Additions, and the Calamares graphical installer.

## Architecture & Verified Sources

- **Base OS**: Debian 13 (`trixie`, `amd64`) built with [Debian live-build](https://packages.debian.org/trixie/live-build) (`--binary-images iso-hybrid`, `--bootloaders "syslinux,grub-efi"`).
- **Desktop Environment**: Minimal [KDE Plasma 6](https://packages.debian.org/trixie/plasma-desktop) (`plasma-desktop`, `kwin-x11`, `sddm`, `sddm-theme-breeze`) defaulting to X11 so VirtualBox display resizing and bidirectional clipboard work reliably out of the box.
- **Windows 11 Theme & Icons**: Installed system-wide in chroot from [vinceliuice/Fluent-kde](https://github.com/vinceliuice/Fluent-kde) (`--round` Light/Dark Plasma themes, color schemes, and rounded Aurorae decorations) and [yeyushengfan258/Win11-icon-theme](https://github.com/yeyushengfan258/win11-icon-theme), paired with a bundled SVG Fluent Bloom wallpaper and a first-login Plasma 6 D-Bus layout script (`/usr/local/bin/win11-apply-layout.sh`) that builds a centered floating bottom taskbar for every new user via `/etc/skel`.
- **Core Apps**: [Dolphin](https://packages.debian.org/trixie/amd64/dolphin), [Firefox ESR](https://packages.debian.org/trixie/source/firefox-esr), [Kate](https://packages.debian.org/trixie/kate), [Konsole](https://packages.debian.org/trixie/konsole), [KCalc](https://packages.debian.org/trixie/source/kcalc), and System Settings (`systemsettings`).
- **VirtualBox Guest Additions**: Installed in chroot (`virtualbox-guest-utils`, `virtualbox-guest-x11`) via [Debian Fast Track](https://fasttrack.debian.net/) (`trixie-fasttrack` + `trixie-backports-staging`, per the [Debian VirtualBox Wiki](https://wiki.debian.org/VirtualBox)) using [fasttrack-archive-keyring](https://packages.debian.org/unstable/fasttrack-archive-keyring), because VirtualBox guest packages are not shipped in Debian's standard `trixie` main/contrib repositories.
- **Graphical Installer**: [Calamares](https://packages.debian.org/source/calamares) + [calamares-settings-debian](https://packages.debian.org/calamares-settings-debian), backed by separate binary pools (`grub-pc.list.binary` and `grub-efi.list.binary`) so offline Legacy BIOS and UEFI installations to a VirtualBox VDI succeed without network dependency ([FlickOS live-build reference](https://flickos.vercel.app/docs/03-live-build-config/)).

## Project Directory Structure

```text
win11clone-os-build/
├── build.sh
├── README.md
└── project-config/
    ├── package-lists/
    │   ├── core.list.chroot
    │   ├── desktop.list.chroot
    │   ├── apps.list.chroot
    │   ├── installer.list.chroot
    │   ├── grub-pc.list.binary
    │   └── grub-efi.list.binary
    ├── hooks/
    │   └── normal/
    │       ├── 0100-virtualbox-guest.hook.chroot
    │       ├── 0200-win11-theme.hook.chroot
    │       └── 0300-system-branding.hook.chroot
    └── includes.chroot/
        ├── etc/
        │   ├── sddm.conf.d/
        │   │   └── 10-win11clone.conf
        │   └── skel/
        │       └── .config/
        │           ├── autostart/
        │           │   └── win11-layout-init.desktop
        │           ├── kdeglobals
        │           ├── kwinrc
        │           └── plasmarc
        └── usr/
            ├── local/
            │   └── bin/
            │       └── win11-apply-layout.sh
            └── share/
                ├── sddm/
                │   └── themes/
                │       └── breeze/
                │           └── theme.conf.user
                └── wallpapers/
                    └── Win11Clone/
                        ├── metadata.json
                        └── contents/
                            └── images/
                                └── 1920x1080.svg
```

## Build Instructions (Ubuntu / Debian / WSL2)

### Host Prerequisites

- **OS**: Debian 12/13 or Ubuntu 22.04/24.04 (`x86_64`).
- **Disk Space**: At least **20 GB** of free space on a native Linux filesystem (`ext4`).
- **WSL2 Note**: Extract and run the project inside your WSL2 Linux home directory (for example `~/win11clone-os-build`), **never** under `/mnt/c/`, because NTFS/9p breaks `debootstrap` permissions, symlinks, and device nodes.

### Build Commands

```bash
# 1. Extract the project archive onto a native Linux filesystem
unzip Win11Clone-OS-build.zip -d ~
cd ~/win11clone-os-build

# 2. Ensure the build script is executable
chmod +x build.sh

# 3. Run the automated build (installs host dependencies, builds chroot, compiles ISO)
sudo ./build.sh
```

When complete (typically 15–30 minutes depending on network speed), your deliverables are located at:

- `out/Win11Clone-OS.iso`
- `out/Win11Clone-OS.iso.sha256`
- `out/build.log`

Verify integrity before importing into VirtualBox:

```bash
sha256sum -c out/Win11Clone-OS.iso.sha256
```

## Recommended VirtualBox VM Settings

| Setting | Recommended Value | Notes |
| --- | --- | --- |
| **Type / Version** | Linux / Debian (64-bit) | Matches Debian 13 (`amd64`) kernel |
| **Base Memory (RAM)** | 4096 MB (4 GB) minimum (8 GB ideal) | Smooth Plasma 6 + Calamares live session |
| **Processors (CPU)** | 2–4 vCPUs (Enable PAE/NX) | Speeds up SquashFS decompression and install |
| **Video Memory (VRAM)** | 128 MB | Required for Plasma 6 blur/compositing |
| **Graphics Controller** | `VMSVGA` | Standard driver for Linux + `virtualbox-guest-x11` |
| **3D Acceleration** | Disabled initially (optional after install) | Avoids black-screen compositing glitches on some hosts |
| **Firmware (BIOS / UEFI)** | Either Legacy BIOS or Enable EFI (both supported) | ISO is dual-boot hybrid (`syslinux` + `grub-efi`) |
| **Virtual Hard Disk (VDI)** | 25 GB+ dynamically allocated | Target disk for permanent Calamares installation |
| **Shared Clipboard** | Bidirectional (Devices → Shared Clipboard) | Works out of the box via `virtualbox-guest-x11` |

## Testing & Permanent Installation Steps

1. Attach `out/Win11Clone-OS.iso` to the VM's virtual optical drive and start the VM.
2. Select **Live system (amd64)** at the boot menu (works in both Legacy BIOS and UEFI mode).
3. Verify VirtualBox integration: resize the VirtualBox window (display auto-resizes) and test copy/paste between host and guest.
4. Double-click **Install Win11Clone OS** on the desktop to launch Calamares, choose **Erase disk** on the VDI, create your user account, and complete installation.
5. Power off the VM, detach `Win11Clone-OS.iso` from the optical drive, and boot directly from the installed VDI. Your new user account automatically inherits `/etc/skel` and receives the centered floating Windows 11 taskbar, Fluent theme, Win11 icons, and wallpaper on first login.
6. To switch between **Light** and **Dark** Fluent themes at any time, open **System Settings → Colors & Themes → Global Theme** and select `Fluent-round-light` or `Fluent-round-dark`.
