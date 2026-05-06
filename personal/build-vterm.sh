#!/usr/bin/env bash
#
# build-vterm.sh - Automated vterm native module builder
#
# Usage: bash ~/.emacs.d/personal/build-vterm.sh
#

set -e

echo "================================================================"
echo "vterm Native Module Builder"
echo "================================================================"
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Find vterm directory
VTERM_DIR=$(find ~/.emacs.d/elpa -maxdepth 1 -name "vterm-*" -type d | head -1)

if [ -z "$VTERM_DIR" ]; then
    echo -e "${RED}ERROR: vterm package not found in ~/.emacs.d/elpa/${NC}"
    echo "Please install it first:"
    echo "  1. Open Emacs"
    echo "  2. M-x package-refresh-contents"
    echo "  3. M-x package-install RET vterm RET"
    exit 1
fi

echo -e "${GREEN}✓${NC} Found vterm: $VTERM_DIR"
echo

# Check prerequisites
echo "Checking prerequisites..."
echo "------------------------------------------------------------"

# Check cmake
if ! command -v cmake &> /dev/null; then
    echo -e "${RED}✗${NC} cmake not found"
    echo "Install with: brew install cmake"
    exit 1
fi
echo -e "${GREEN}✓${NC} cmake: $(cmake --version | head -1)"

# Check if libvterm is installed
if ! brew list libvterm &> /dev/null; then
    echo -e "${YELLOW}!${NC} libvterm not installed"
    echo "Installing libvterm via Homebrew..."
    brew install libvterm
    echo -e "${GREEN}✓${NC} libvterm installed"
else
    echo -e "${GREEN}✓${NC} libvterm: $(brew --prefix libvterm)"
fi

echo

# Build the module
echo "Building vterm native module..."
echo "------------------------------------------------------------"

cd "$VTERM_DIR"

# Clean previous build
if [ -d "build" ]; then
    echo "Cleaning previous build..."
    rm -rf build
fi

# Create build directory
mkdir -p build
cd build

# Configure with CMake
echo "Running cmake..."
if cmake .. ; then
    echo -e "${GREEN}✓${NC} CMake configuration successful"
else
    echo -e "${RED}✗${NC} CMake configuration failed"
    echo
    echo "Trying with explicit libvterm path..."
    LIBVTERM_PREFIX=$(brew --prefix libvterm)
    cmake -DLIBVTERM_INCLUDE_DIR="$LIBVTERM_PREFIX/include" \
          -DLIBVTERM_LIBRARY="$LIBVTERM_PREFIX/lib/libvterm.dylib" \
          ..
fi

echo

# Build
echo "Running make..."
if make ; then
    echo -e "${GREEN}✓${NC} Build successful"
else
    echo -e "${RED}✗${NC} Build failed"
    exit 1
fi

echo

# Verify the module was created
echo "Verifying build..."
echo "------------------------------------------------------------"

MODULE_FILE=$(find . -name "vterm-module.so" -o -name "vterm-module.dylib" | head -1)

if [ -z "$MODULE_FILE" ]; then
    echo -e "${RED}✗${NC} Module file not found"
    exit 1
fi

MODULE_SIZE=$(ls -lh "$MODULE_FILE" | awk '{print $5}')
echo -e "${GREEN}✓${NC} Module created: $MODULE_FILE ($MODULE_SIZE)"

# Copy module to parent directory if needed
if [ "$(dirname "$MODULE_FILE")" != "$VTERM_DIR" ]; then
    echo "Copying module to parent directory..."
    cp "$MODULE_FILE" "$VTERM_DIR/"
    echo -e "${GREEN}✓${NC} Module copied to: $VTERM_DIR/$(basename $MODULE_FILE)"
fi

echo
echo "================================================================"
echo "Build Complete!"
echo "================================================================"
echo
echo "Next steps:"
echo
echo "1. Test vterm in Emacs:"
echo "   M-x vterm"
echo
echo "2. Update Claude Code IDE to use vterm:"
echo "   Edit: ~/.emacs.d/personal/my_claude_code_ide.el"
echo "   Change line 44 from:"
echo "     (claude-code-ide-terminal-backend 'eat)"
echo "   To:"
echo "     (claude-code-ide-terminal-backend 'vterm)"
echo
echo "3. Restart Emacs"
echo
echo "4. Test Claude Code IDE:"
echo "   M-x claude-code-ide"
echo
echo "See VTERM_SETUP.md for detailed configuration options."
echo
