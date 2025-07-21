# #!/bin/bash
# set -euo pipefail

# # Use xcode-select to make sure Xcode is selected
# echo "🔧 Setting Xcode as default with xcode-select..."
# sudo xcode-select -s "/Applications/Xcode.app/Contents/Developer"

# # Optional: export DEVELOPER_DIR to ensure consistency
# export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
# echo "✅ DEVELOPER_DIR set to $DEVELOPER_DIR"

# # Show paths
# echo "✅ SDK Path: $(xcrun --sdk macosx --show-sdk-path)"
# echo "✅ cc: $(xcrun -f cc)"
# echo "✅ c++: $(xcrun -f c++)"
# echo "✅ ld: $(xcrun -f ld)"

# #!/bin/bash
# set -euo pipefail

# echo "🔧 Setting Xcode as default with xcode-select..."

# # Ensure Xcode is selected
# sudo xcode-select -s "/Applications/Xcode.app/Contents/Developer"

# # Export DEVELOPER_DIR for provisioning time
# export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

# echo "✅ DEVELOPER_DIR set to $DEVELOPER_DIR"

# # Validate SDK path
# sdk_path="$(xcrun --sdk macosx --show-sdk-path)"
# echo "✅ SDK Path: $sdk_path"

# # Check cc, c++, and ld
# echo "✅ cc: $(xcrun -f cc)"
# echo "✅ c++: $(xcrun -f c++)"
# echo "✅ ld: $(xcrun -f ld)"

# # Optional: Write DEVELOPER_DIR to /etc/zprofile for shells that use zsh (macOS default)
# if ! grep -q "DEVELOPER_DIR=" /etc/zprofile 2>/dev/null; then
#   echo "export DEVELOPER_DIR=$DEVELOPER_DIR" | sudo tee -a /etc/zprofile > /dev/null
#   echo "✅ DEVELOPER_DIR added to /etc/zprofile"
# fi

# # Optional: write to /etc/bashrc as well if using bash
# if ! grep -q "DEVELOPER_DIR=" /etc/bashrc 2>/dev/null; then
#   echo "export DEVELOPER_DIR=$DEVELOPER_DIR" | sudo tee -a /etc/bashrc > /dev/null
#   echo "✅ DEVELOPER_DIR added to /etc/bashrc"
# fi

# #!/bin/bash
# set -euo pipefail

# XCODE_PATH="/Applications/Xcode_16.app"

# echo "🔧 Setting Xcode 16.0 as default with xcode-select..."
# sudo xcode-select -s "${XCODE_PATH}"

# DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
# SDKROOT="${DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

# echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
# echo "✅ SDKROOT: $SDKROOT"

# # Export for current shell
# export DEVELOPER_DIR="$DEVELOPER_DIR"
# export SDKROOT="$SDKROOT"

# # Export for all future GitHub Actions steps
# echo "DEVELOPER_DIR=$DEVELOPER_DIR" >> "$GITHUB_ENV"
# echo "SDKROOT=$SDKROOT" >> "$GITHUB_ENV"

# # Show effective paths
# echo "✅ cc: $(xcrun -f cc)"
# echo "✅ SDK Path via xcrun: $(xcrun --show-sdk-path)"


#!/usr/bin/env bash
set -euo pipefail

XCODE_PATH="/Applications/Xcode_16.app"
XCODE_DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
XCODE_SDK_PATH="${XCODE_DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "🔧 Switching to Xcode 16 at: ${XCODE_PATH}"
sudo xcode-select -s "${XCODE_DEVELOPER_DIR}"

echo "🔧 Persisting DEVELOPER_DIR + SDKROOT system‑wide…"
sudo mkdir -p /etc/profile.d /etc/zprofile.d

# Drop a file that every login AND non‑login shell will source
sudo tee /etc/profile.d/xcode-sdk.sh >/dev/null <<EOF
export DEVELOPER_DIR="${XCODE_DEVELOPER_DIR}"
export SDKROOT="${XCODE_SDK_PATH}"
EOF

# For zsh login shells:
sudo tee /etc/zprofile.d/xcode-sdk.zsh >/dev/null <<EOF
export DEVELOPER_DIR="${XCODE_DEVELOPER_DIR}"
export SDKROOT="${XCODE_SDK_PATH}"
EOF

# Also export in this running shell so subsequent commands in this script see it:
export DEVELOPER_DIR="${XCODE_DEVELOPER_DIR}"
export SDKROOT="${XCODE_SDK_PATH}"

# If we're in GitHub Actions, safely append to GITHUB_ENV (only if defined):
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "🔄 Exporting to GITHUB_ENV for Actions…"
  echo "DEVELOPER_DIR=${DEVELOPER_DIR}" >> "${GITHUB_ENV}"
  echo "SDKROOT=${SDKROOT}"         >> "${GITHUB_ENV}"
fi

# Diagnostics
echo "✅ DEVELOPER_DIR: $(xcode-select -p)"
echo "✅ xcrun   cc: $(xcrun -f cc)"
echo "✅ SDK path: $(xcrun --show-sdk-path)"
echo "✅ clang   : $(clang --version | head -1)"
