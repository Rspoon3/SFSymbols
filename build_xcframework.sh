#!/bin/bash

set -e

PROJECT_DIR="SFSymbolKit"
PROJECT_NAME="${PROJECT_DIR}/SFSymbolKit.xcodeproj"
OUTPUT_NAME=${1:-"SFSymbolKit"}
CONFIGURATION="Release"

# Get absolute path of the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Delete existing SFSymbolKit.xcframework if it exists
if [ -d "$SCRIPT_DIR/SFSymbolKit.xcframework" ]; then
    echo "🗑️ Removing existing SFSymbolKit.xcframework..."
    rm -rf "$SCRIPT_DIR/SFSymbolKit.xcframework"
fi

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

# Build for all platforms
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

echo "💻 Archiving for macOS..."
xcodebuild archive \
  -project "$SCRIPT_DIR/$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=macOS" \
  -archivePath "$ARCHIVE_DIR/macos" \
  -sdk macosx \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "⌚ Archiving for watchOS..."
xcodebuild archive \
  -project "$SCRIPT_DIR/$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=watchOS" \
  -archivePath "$ARCHIVE_DIR/watchos_devices" \
  -sdk watchos \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "⌚ Archiving for watchOS Simulator..."
xcodebuild archive \
  -project "$SCRIPT_DIR/$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=watchOS Simulator" \
  -archivePath "$ARCHIVE_DIR/watchos_sim" \
  -sdk watchsimulator \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "📺 Archiving for tvOS..."
xcodebuild archive \
  -project "$SCRIPT_DIR/$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=tvOS" \
  -archivePath "$ARCHIVE_DIR/tvos_devices" \
  -sdk appletvos \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "📺 Archiving for tvOS Simulator..."
xcodebuild archive \
  -project "$SCRIPT_DIR/$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=tvOS Simulator" \
  -archivePath "$ARCHIVE_DIR/tvos_sim" \
  -sdk appletvsimulator \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "🥽 Archiving for visionOS..."
xcodebuild archive \
  -project "$SCRIPT_DIR/$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=visionOS" \
  -archivePath "$ARCHIVE_DIR/visionos_devices" \
  -sdk xros \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "🥽 Archiving for visionOS Simulator..."
xcodebuild archive \
  -project "$SCRIPT_DIR/$PROJECT_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=visionOS Simulator" \
  -archivePath "$ARCHIVE_DIR/visionos_sim" \
  -sdk xrsimulator \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Look for frameworks in all archives
IOS_FRAMEWORK=$(find "$ARCHIVE_DIR/ios_devices.xcarchive" -name "*.framework" -type d | head -1)
IOS_SIM_FRAMEWORK=$(find "$ARCHIVE_DIR/ios_sim.xcarchive" -name "*.framework" -type d | head -1)
MACOS_FRAMEWORK=$(find "$ARCHIVE_DIR/macos.xcarchive" -name "*.framework" -type d | head -1)
WATCHOS_FRAMEWORK=$(find "$ARCHIVE_DIR/watchos_devices.xcarchive" -name "*.framework" -type d | head -1)
WATCHOS_SIM_FRAMEWORK=$(find "$ARCHIVE_DIR/watchos_sim.xcarchive" -name "*.framework" -type d | head -1)
TVOS_FRAMEWORK=$(find "$ARCHIVE_DIR/tvos_devices.xcarchive" -name "*.framework" -type d | head -1)
TVOS_SIM_FRAMEWORK=$(find "$ARCHIVE_DIR/tvos_sim.xcarchive" -name "*.framework" -type d | head -1)
VISIONOS_FRAMEWORK=$(find "$ARCHIVE_DIR/visionos_devices.xcarchive" -name "*.framework" -type d | head -1)
VISIONOS_SIM_FRAMEWORK=$(find "$ARCHIVE_DIR/visionos_sim.xcarchive" -name "*.framework" -type d | head -1)

# Check if we found all frameworks
FRAMEWORKS=("$IOS_FRAMEWORK" "$IOS_SIM_FRAMEWORK" "$MACOS_FRAMEWORK" "$WATCHOS_FRAMEWORK" "$WATCHOS_SIM_FRAMEWORK" "$TVOS_FRAMEWORK" "$TVOS_SIM_FRAMEWORK" "$VISIONOS_FRAMEWORK" "$VISIONOS_SIM_FRAMEWORK")
FRAMEWORK_NAMES=("iOS" "iOS Simulator" "macOS" "watchOS" "watchOS Simulator" "tvOS" "tvOS Simulator" "visionOS" "visionOS Simulator")

echo "📋 Found frameworks:"
for i in "${!FRAMEWORKS[@]}"; do
    if [[ -n "${FRAMEWORKS[$i]}" ]]; then
        echo "${FRAMEWORK_NAMES[$i]}: ${FRAMEWORKS[$i]}"
    else
        echo "❌ Missing framework for ${FRAMEWORK_NAMES[$i]}"
    fi
done

# Build XCFramework arguments
XCFRAMEWORK_ARGS=()
for framework in "${FRAMEWORKS[@]}"; do
    if [[ -n "$framework" ]]; then
        XCFRAMEWORK_ARGS+=("-framework" "$framework")
    fi
done

if [[ ${#XCFRAMEWORK_ARGS[@]} -eq 0 ]]; then
    echo "❌ No frameworks found to create XCFramework"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "🧱 Creating XCFramework..."
xcodebuild -create-xcframework \
  "${XCFRAMEWORK_ARGS[@]}" \
  -output "$XCFRAMEWORK_OUTPUT"

echo
echo "✅ XCFramework created at:"
echo "$XCFRAMEWORK_OUTPUT"

FINAL_OUTPUT="$SCRIPT_DIR/${OUTPUT_NAME}.xcframework"
cp -R "$XCFRAMEWORK_OUTPUT" "$FINAL_OUTPUT"
echo "📦 XCFramework copied to: $FINAL_OUTPUT"

echo "🧹 Cleaning up..."
rm -rf "$TMP_DIR"

# Clean up source files from SFSymbolKit/SFSymbolKit
echo "🧹 Cleaning up source files from SFSymbolKit/SFSymbolKit..."
rm -rf "$SCRIPT_DIR/$PROJECT_DIR/SFSymbolKit/"*

echo "🎉 Done!"
echo
echo "💡 Import the module using: import $SCHEME_NAME"
