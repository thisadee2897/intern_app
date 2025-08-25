#!/bin/bash

# 🚀 Build and Release Script for InternApp
# ใช้สำหรับ build และสร้าง release ในเครื่อง

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if version is provided
if [ $# -eq 0 ]; then
    print_error "Usage: $0 <version>"
    print_error "Example: $0 1.0.1"
    exit 1
fi

VERSION=$1
TAG_NAME="v$VERSION"

print_status "🚀 Starting build and release process for version $VERSION"

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the Flutter project root."
    exit 1
fi

# Create releases directory
mkdir -p releases/$VERSION
cd releases/$VERSION

# Update pubspec.yaml version
print_status "📝 Updating version in pubspec.yaml"
cd ../..
sed -i.bak "s/^version: .*/version: $VERSION+1/" pubspec.yaml
print_success "Version updated to $VERSION"

# Get dependencies
print_status "📦 Getting Flutter dependencies"
flutter pub get

# Clean previous builds
print_status "🧹 Cleaning previous builds"
flutter clean

# Build based on platform
case "$(uname -s)" in
    Darwin*)
        print_status "🍎 Building for macOS"
        flutter build macos --release
        
        print_status "📦 Creating DMG"
        mkdir -p releases/$VERSION/macos
        cp -R build/macos/Build/Products/Release/project.app releases/$VERSION/macos/
        
        # Create DMG (requires create-dmg: brew install create-dmg)
        if command -v create-dmg &> /dev/null; then
            create-dmg \
                --volname "InternApp" \
                --window-pos 200 120 \
                --window-size 600 300 \
                --icon-size 100 \
                --icon "project.app" 175 120 \
                --hide-extension "project.app" \
                --app-drop-link 425 120 \
                "releases/$VERSION/InternApp-macOS-$TAG_NAME.dmg" \
                "releases/$VERSION/macos/"
            print_success "DMG created: releases/$VERSION/InternApp-macOS-$TAG_NAME.dmg"
        else
            print_warning "create-dmg not found. Install with: brew install create-dmg"
            print_status "Creating ZIP instead"
            cd releases/$VERSION/macos
            zip -r "../InternApp-macOS-$TAG_NAME.zip" .
            cd ../../..
            print_success "ZIP created: releases/$VERSION/InternApp-macOS-$TAG_NAME.zip"
        fi
        ;;
        
    MINGW*|CYGWIN*|MSYS*)
        print_status "🪟 Building for Windows"
        flutter build windows --release
        
        print_status "📦 Creating Windows package"
        mkdir -p releases/$VERSION/windows
        cp -r build/windows/x64/runner/Release/* releases/$VERSION/windows/
        
        # Create ZIP
        cd releases/$VERSION
        powershell -Command "Compress-Archive -Path 'windows/*' -DestinationPath 'InternApp-Windows-$TAG_NAME.zip'"
        cd ../..
        print_success "Windows build created: releases/$VERSION/InternApp-Windows-$TAG_NAME.zip"
        ;;
        
    *)
        print_error "Unsupported platform: $(uname -s)"
        exit 1
        ;;
esac

# Create release notes
print_status "📝 Creating release notes"
cat > releases/$VERSION/RELEASE_NOTES.md << EOF
# Release Notes - Version $VERSION

## 🎉 What's New

### ✨ Features
- New feature 1
- New feature 2

### 🐛 Bug Fixes
- Fixed issue 1
- Fixed issue 2

### 🔧 Improvements
- Performance improvements
- UI/UX enhancements

## 📥 Installation

### Windows
1. Download \`InternApp-Windows-$TAG_NAME.zip\`
2. Extract the ZIP file
3. Run \`project.exe\`

### macOS
1. Download \`InternApp-macOS-$TAG_NAME.dmg\`
2. Open the DMG file
3. Drag the app to Applications folder

## 🔄 Auto Update

The app will automatically check for updates every 6 hours.
You can also manually check for updates in the Settings.

---

**Build Date**: $(date)
**Git Commit**: $(git rev-parse --short HEAD)
**Platform**: $(uname -s)
EOF

print_success "Release notes created: releases/$VERSION/RELEASE_NOTES.md"

# Commit version change
print_status "📝 Committing version change"
git add pubspec.yaml
git commit -m "chore: bump version to $VERSION" || print_warning "No changes to commit"

# Create Git tag
print_status "🏷️ Creating Git tag"
git tag -a "$TAG_NAME" -m "Release version $VERSION"
print_success "Git tag $TAG_NAME created"

# Show summary
print_success "🎉 Build and release process completed!"
echo
print_status "📂 Files created in releases/$VERSION/:"
ls -la releases/$VERSION/
echo
print_status "🚀 Next steps:"
echo "1. Test the built application"
echo "2. Push the tag: git push origin $TAG_NAME"
echo "3. GitHub Actions will automatically create a release"
echo "4. Or manually upload files to GitHub Releases"
echo
print_status "🔄 Auto Update Setup:"
echo "The app will check for updates from: https://api.github.com/repos/thisadee2897/intern_app/releases/latest"
echo "Make sure to push the tag to trigger GitHub release creation"
