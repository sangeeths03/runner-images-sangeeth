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


#!/bin/bash
set -euo pipefail

XCODE_PATH="/Applications/Xcode_16.app"
DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
SDKROOT="${DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
CC_PATH="${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc"
CXX_PATH="${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++"
LD_PATH="${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld"

echo "🔧 Switching to Xcode 16 at: $XCODE_PATH"
sudo xcode-select -s "$XCODE_PATH"

# Export for current shell session
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
export CC="$CC_PATH"
export CXX="$CXX_PATH"
export LD="$LD_PATH"

# Persist for GitHub Actions
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "Exporting vars to GITHUB_ENV"
  echo "DEVELOPER_DIR=$DEVELOPER_DIR" >> "$GITHUB_ENV"
  echo "SDKROOT=$SDKROOT" >> "$GITHUB_ENV"
  echo "CC=$CC_PATH" >> "$GITHUB_ENV"
  echo "CXX=$CXX_PATH" >> "$GITHUB_ENV"
  echo "LD=$LD_PATH" >> "$GITHUB_ENV"
fi

# Persist for future login shells (for image-gen)
if [[ -f /etc/zprofile ]]; then
  echo "📌 Persisting to /etc/zprofile and /etc/profile..."
  sudo tee -a /etc/zprofile >/dev/null <<EOF
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
export CC="$CC_PATH"
export CXX="$CXX_PATH"
export LD="$LD_PATH"
EOF

  sudo tee -a /etc/profile >/dev/null <<EOF
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
export CC="$CC_PATH"
export CXX="$CXX_PATH"
export LD="$LD_PATH"
EOF
fi

# Diagnostics
echo ""
echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
echo "✅ SDKROOT:       $SDKROOT"
echo "✅ cc path:       $(xcrun -f cc)"
echo "✅ SDK path:      $(xcrun --show-sdk-path)"
echo "✅ xcode-select:  $(xcode-select -p)"
echo "✅ Apple clang:   $(cc --version | head -n 1)"

