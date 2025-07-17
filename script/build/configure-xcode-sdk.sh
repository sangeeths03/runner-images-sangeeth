#!/bin/bash
set -euo pipefail

# Use xcode-select to make sure Xcode is selected
echo "🔧 Setting Xcode as default with xcode-select..."
sudo xcode-select -s "/Applications/Xcode.app/Contents/Developer"

# Optional: export DEVELOPER_DIR to ensure consistency
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
echo "✅ DEVELOPER_DIR set to $DEVELOPER_DIR"

# Show paths
echo "✅ SDK Path: $(xcrun --sdk macosx --show-sdk-path)"
echo "✅ cc: $(xcrun -f cc)"
echo "✅ c++: $(xcrun -f c++)"
echo "✅ ld: $(xcrun -f ld)"

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
