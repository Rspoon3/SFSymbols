#!/bin/bash

set -e

PROJECT_DIR="SFSymbolKit"
PROJECT_NAME="${PROJECT_DIR}/SFSymbolKit.xcodeproj"
OUTPUT_NAME=${1:-"SFSymbolKit"}
CONFIGURATION="Release"

# Get absolute path of the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy files from Sources to SFSymbolKit/SFSymbolKit directory
echo "📁 Copying source files from Sources to SFSymbolKit/SFSymbolKit..."
if [ -d "$SCRIPT_DIR/Sources" ]; then
    # Nuke everything in SFSymbolKit/SFSymbolKit directory
    rm -rf "$SCRIPT_DIR/$PROJECT_DIR/SFSymbolKit/"*
    
    # Copy all contents from Sources to SFSymbolKit/SFSymbolKit
    cp -R "$SCRIPT_DIR/Sources/"* "$SCRIPT_DIR/$PROJECT_DIR/SFSymbolKit/"
    echo "✅ Source files copied successfully"
else
    echo "❌ Sources directory not found at: $SCRIPT_DIR/Sources"
    exit 1
fi

# Check if project exists
if [ ! -d "$SCRIPT_DIR/$PROJECT_NAME" ]; then
    echo "❌ Project not found at: $SCRIPT_DIR/$PROJECT_NAME"
    exit 1
fi

echo "🔍 Detecting available schemes..."
SCHEMES=$(xcodebuild -project "$SCRIPT_DIR/$PROJECT_NAME" -list -json | jq -r '.project.schemes[]' 2>/dev/null || true)

if [ -z "$SCHEMES" ]; then
    # Fallback method without jq
    echo "📋 Available schemes:"
    xcodebuild -project "$SCRIPT_DIR/$PROJECT_NAME" -list
    echo ""
    echo "❌ Could not auto-detect scheme. Please specify the scheme name as:"
    echo "   SCHEME_NAME=\"YourSchemeName\" $0"
    exit 1
fi

# Use the first scheme if SCHEME_NAME is not set
if [ -z "$SCHEME_NAME" ]; then
    SCHEME_NAME=$(echo "$SCHEMES" | head -1)
    echo "🎯 Auto-detected scheme: $SCHEME_NAME"
else
    echo "🎯 Using specified scheme: $SCHEME_NAME"
fi

# Verify the scheme exists
if ! echo "$SCHEMES" | grep -q "^$SCHEME_NAME$"; then
    echo "❌ Scheme '$SCHEME_NAME' not found in project."
    echo "📋 Available schemes:"
    echo "$SCHEMES"
    exit 1
fi

TMP_DIR=$(mktemp -d)
BUILD_DIR="$TMP_DIR/build"
ARCHIVE_DIR="$BUILD_DIR/archives"
XCFRAMEWORK_OUTPUT="$BUILD_DIR/${OUTPUT_NAME}.xcframework"

mkdir -p "$ARCHIVE_DIR"

echo "📲 Archiving for iOS..."
xcodebuild archive \
  -project "$SCRIPT_DIR/$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_DIR/ios_devices" \
  -sdk iphoneos \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "🖥  Archiving for iOS Simulator..."
xcodebuild archive \
  -project "$SCRIPT_DIR/$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$ARCHIVE_DIR/ios_sim" \
  -sdk iphonesimulator \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Look for any .framework in the archives (more flexible)
IOS_FRAMEWORK=$(find "$ARCHIVE_DIR/ios_devices.xcarchive" -name "*.framework" -type d | head -1)
SIM_FRAMEWORK=$(find "$ARCHIVE_DIR/ios_sim.xcarchive" -name "*.framework" -type d | head -1)

if [[ -z "$IOS_FRAMEWORK" || -z "$SIM_FRAMEWORK" ]]; then
    echo "❌ Failed to find framework archives"
    echo "Available frameworks in iOS archive:"
    find "$ARCHIVE_DIR/ios_devices.xcarchive" -name "*.framework" -type d || echo "None found"
    echo "Available frameworks in Simulator archive:"
    find "$ARCHIVE_DIR/ios_sim.xcarchive" -name "*.framework" -type d || echo "None found"
    
    echo ""
    echo "🔍 Archive contents:"
    echo "iOS archive:"
    ls -la "$ARCHIVE_DIR/ios_devices.xcarchive/Products/" 2>/dev/null || echo "No Products directory"
    echo "Simulator archive:"
    ls -la "$ARCHIVE_DIR/ios_sim.xcarchive/Products/" 2>/dev/null || echo "No Products directory"
    
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "📋 Found frameworks:"
echo "iOS: $IOS_FRAMEWORK"
echo "Simulator: $SIM_FRAMEWORK"

echo "🧱 Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$IOS_FRAMEWORK" \
  -framework "$SIM_FRAMEWORK" \
  -output "$XCFRAMEWORK_OUTPUT"

echo
echo "✅ XCFramework created at:"
echo "$XCFRAMEWORK_OUTPUT"

FINAL_OUTPUT="$SCRIPT_DIR/${OUTPUT_NAME}.xcframework"
cp -R "$XCFRAMEWORK_OUTPUT" "$FINAL_OUTPUT"
echo "📦 XCFramework copied to: $FINAL_OUTPUT"

echo "🧹 Cleaning up..."
rm -rf "$TMP_DIR"

echo "🎉 Done!"
echo
echo "💡 Import the module using: import $SCHEME_NAME"
