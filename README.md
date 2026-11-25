# The Nexus OS 1.0 (Debian 13 Trixie + KDE Plasma 6)

Complete `live-build` OS distribution repository pre-loaded with your exact **The Nexus OS** UI, **Light Streaks** wallpaper, **2.5D Gradient `N` + 31 Color + 21 White Symbolic** FreeDesktop icon theme, **Hybrid Frosted Header / Solid Dark** window theme, automated Plasma 6 **Top Notch + Floating Dock + Right System Tray** layout, box-free **SDDM Login Screen**, and **Plymouth** boot splash.

## Quick Build via GitHub Actions (No Local Linux Needed)
1. Unzip this repository and push all files to a GitHub repository (`main` branch).
2. Open the **Actions** tab and run **Build The Nexus OS 1.0 ISO**.
3. Download **`NexusOS-1.0-amd64.iso`** from the workflow artifacts.
4. Boot in **VirtualBox** (Type: Linux / Debian 64-bit, 4 GB+ RAM, 128 MB Video Memory, VMSVGA + 3D Acceleration enabled). Default live login: `live` / `live`.

## Optional: Use Proprietary Apple SF Pro Display
By default, `/etc/fonts/local.conf` maps `SF Pro Display` to `Inter Display`. To use Apple's `.otf` files directly, place them in `config/includes.chroot/usr/local/share/fonts/SFPro/` before building.
