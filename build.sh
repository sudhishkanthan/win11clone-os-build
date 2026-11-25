#!/bin/bash
set -euo pipefail
echo "=== Building The Nexus OS 1.0 (Debian 13 Trixie amd64) ==="
sudo lb clean --purge || true
sudo lb config
sudo lb build
mv -f live-image-amd64.hybrid.iso NexusOS-1.0-amd64.iso
echo "=== Build Complete: NexusOS-1.0-amd64.iso ==="
