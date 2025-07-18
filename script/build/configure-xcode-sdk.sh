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
set -e

XCODE_PATH="/Applications/Xcode_16.app/Contents/Developer"
SDK_PATH="$XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
PROFILE_FILE="/etc/profile.d/xcode.sh"

echo "🔧 Setting system to use Xcode from: $XCODE_PATH"
echo "🔧 SDK path: $SDK_PATH"

# 1. Point xcode-select to Xcode
sudo xcode-select -s "$XCODE_PATH"
echo "✅ xcode-select -> $(xcode-select -p)"

# 2. Create profile script to export DEVELOPER_DIR and SDKROOT for all future shells
sudo tee "$PROFILE_FILE" > /dev/null <<EOF
export DEVELOPER_DIR="$XCODE_PATH"
export SDKROOT="$SDK_PATH"
EOF
sudo chmod +x "$PROFILE_FILE"

echo "✅ Wrote environment variables to: $PROFILE_FILE"

# 3. Verify results
echo "👉 xcode-select path: $(xcode-select -p)"
echo "👉 xcrun cc: $(xcrun -f cc)"
echo "👉 SDK path: $(xcrun --sdk macosx --show-sdk-path)"
echo "👉 DEVELOPER_DIR: $DEVELOPER_DIR"
echo "👉 SDKROOT: $SDKROOT"

# 4. Test compilation (optional)
echo '#include <stdio.h>\nint main() { printf("✅ Hello from Xcode SDK!\\n"); return 0; }' > test.c
cc test.c -o test
./test
rm test test.c
