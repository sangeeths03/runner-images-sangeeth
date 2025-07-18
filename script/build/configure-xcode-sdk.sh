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
DEVELOPER_DIR="$XCODE_PATH/Contents/Developer"
SDKROOT="$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "🔧 Switching to Xcode 16 at: $XCODE_PATH"
sudo xcode-select -s "$XCODE_PATH"

echo "🔧 Setting environment variables..."
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"

# ✅ Persist to global shell profiles
for file in /etc/zshrc /etc/bashrc; do
  sudo grep -qxF "export DEVELOPER_DIR=\"$DEVELOPER_DIR\"" "$file" || echo "export DEVELOPER_DIR=\"$DEVELOPER_DIR\"" | sudo tee -a "$file" > /dev/null
  sudo grep -qxF "export SDKROOT=\"$SDKROOT\"" "$file" || echo "export SDKROOT=\"$SDKROOT\"" | sudo tee -a "$file" > /dev/null
done

# ✅ Critical: Create /etc/profile.d/xcode.sh for system-wide env
echo "🔧 Creating /etc/profile.d/xcode.sh"
sudo tee /etc/profile.d/xcode.sh > /dev/null <<EOF
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
EOF
sudo chmod +x /etc/profile.d/xcode.sh

# ✅ Final verification
echo ""
echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
echo "✅ SDKROOT:       $SDKROOT"
echo "✅ xcode-select:  $(xcode-select -p)"
echo "✅ cc path:       $(xcrun -f cc)"
echo "✅ SDK path:      $(xcrun --sdk macosx --show-sdk-path)"
echo "✅ Apple clang:   $(cc --version | head -n 1)"

# ✅ Test compilation
echo "👉 Compiling a simple C program using selected SDK..."
cat <<EOF > /tmp/test.c
#include <stdio.h>
int main() { printf("Xcode SDK Test\\n"); return 0; }
EOF

cc /tmp/test.c -o /tmp/test.out

if [[ -x /tmp/test.out ]]; then
  echo "✅ C compilation succeeded with selected SDK!"
  /tmp/test.out
else
  echo "❌ C compilation failed"
  exit 1
fi
