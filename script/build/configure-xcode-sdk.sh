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

#!/bin/bash
set -e

echo "🔧 Setting Xcode as default with xcode-select..."

# Automatically detect latest installed Xcode
XCODE_DIR=$(ls -d /Applications/Xcode*.app | sort -V | tail -n 1)

# Set Xcode as the default path for developer tools
sudo xcode-select -s "$XCODE_DIR/Contents/Developer"
export DEVELOPER_DIR="$XCODE_DIR/Contents/Developer"

echo "✅ DEVELOPER_DIR set to $DEVELOPER_DIR"

# Print SDK and toolchain info for verification
SDK_PATH=$(xcrun --show-sdk-path)
echo "✅ SDK Path: $SDK_PATH"

CC=$(xcrun -f cc)
CXX=$(xcrun -f c++)
LD=$(xcrun -f ld)

echo "✅ cc: $CC"
echo "✅ c++: $CXX"
echo "✅ ld: $LD"

