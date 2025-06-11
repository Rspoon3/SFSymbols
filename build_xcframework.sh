#!/bin/bash

set -e

SCHEME_NAME="SFSymbolsFramework"
PROJECT_DIR="SFSymbolsFramework"
PROJECT_NAME="${PROJECT_DIR}/${SCHEME_NAME}.xcodeproj"
OUTPUT_NAME=${1:-$SCHEME_NAME}
CONFIGURATION="Release"

# Get absolute path of the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

IOS_FRAMEWORK=$(find "$ARCHIVE_DIR/ios_devices.xcarchive" -name "${SCHEME_NAME}.framework" -type d | head -1)
SIM_FRAMEWORK=$(find "$ARCHIVE_DIR/ios_sim.xcarchive" -name "${SCHEME_NAME}.framework" -type d | head -1)

if [[ -z "$IOS_FRAMEWORK" || -z "$SIM_FRAMEWORK" ]]; then
    echo "❌ Failed to find framework archives"
    rm -rf "$TMP_DIR"
    exit 1
fi

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
