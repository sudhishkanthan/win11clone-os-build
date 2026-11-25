#!/bin/bash
set -euo pipefail
echo "=== Building The Nexus OS 1.1 (Debian 13 Trixie amd64) ==="
lb clean --purge || true
lb config
lb build
mv -f live-image-amd64.hybrid.iso NexusOS-1.1-amd64.iso
echo "=== Build Complete: NexusOS-1.1-amd64.iso ==="
