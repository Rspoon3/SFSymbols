#!/bin/bash

set -e

PACKAGE_PATH=$1
PACKAGE_TARGET=$2
OUTPUT_NAME=${3:-$PACKAGE_TARGET}

if [[ -z "$PACKAGE_PATH" || -z "$PACKAGE_TARGET" ]]; then
  echo "❌ Usage: ./build_xcframework.sh <path-to-swift-package> <target-name> [output-name]"
  exit 1
fi

PACKAGE_ABS_PATH=$(cd "$PACKAGE_PATH" && pwd)
WRAPPER_NAME="${PACKAGE_TARGET}Wrapper"
TMP_DIR=$(mktemp -d)
WRAPPER_DIR="$TMP_DIR/$WRAPPER_NAME"
BUILD_DIR="$WRAPPER_DIR/build"
ARCHIVE_DIR="$BUILD_DIR/archives"
XCFRAMEWORK_OUTPUT="$BUILD_DIR/${OUTPUT_NAME}.xcframework"

echo "📁 Creating temporary wrapper SwiftPM package at $WRAPPER_DIR"
mkdir -p "$WRAPPER_DIR/Sources/$WRAPPER_NAME"

# Create Swift file that re-exports the original package
cat > "$WRAPPER_DIR/Sources/$WRAPPER_NAME/ReExport.swift" <<EOF
// Re-export all public symbols from $PACKAGE_TARGET
@_exported import $PACKAGE_TARGET
EOF

# Create Package.swift for the wrapper
cat > "$WRAPPER_DIR/Package.swift" <<EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "$WRAPPER_NAME",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "$WRAPPER_NAME", type: .dynamic, targets: ["$WRAPPER_NAME"])
    ],
    dependencies: [
        .package(path: "$PACKAGE_ABS_PATH")
    ],
    targets: [
        .target(
            name: "$WRAPPER_NAME",
            dependencies: ["$PACKAGE_TARGET"],
            path: "Sources/$WRAPPER_NAME"
        )
    ]
)
EOF

mkdir -p "$ARCHIVE_DIR"

echo "📲 Building for iOS devices..."
cd "$WRAPPER_DIR"
xcodebuild archive \
  -scheme "$WRAPPER_NAME" \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_DIR/ios_devices" \
  -sdk iphoneos \
  -allowProvisioningUpdates \
  -derivedDataPath "$TMP_DIR/DerivedData" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "🖥  Building for iOS Simulator..."
xcodebuild archive \
  -scheme "$WRAPPER_NAME" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$ARCHIVE_DIR/ios_sim" \
  -sdk iphonesimulator \
  -allowProvisioningUpdates \
  -derivedDataPath "$TMP_DIR/DerivedData" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "🔍 Checking archive structure..."
echo "iOS Device archive contents:"
find "$ARCHIVE_DIR/ios_devices.xcarchive" -name "*.framework" -type d 2>/dev/null || echo "No frameworks found in expected location"

echo "iOS Simulator archive contents:"
find "$ARCHIVE_DIR/ios_sim.xcarchive" -name "*.framework" -type d 2>/dev/null || echo "No frameworks found in expected location"

# Find the actual framework paths
IOS_FRAMEWORK=$(find "$ARCHIVE_DIR/ios_devices.xcarchive" -name "${WRAPPER_NAME}.framework" -type d | head -1)
SIM_FRAMEWORK=$(find "$ARCHIVE_DIR/ios_sim.xcarchive" -name "${WRAPPER_NAME}.framework" -type d | head -1)

if [[ -z "$IOS_FRAMEWORK" || -z "$SIM_FRAMEWORK" ]]; then
    echo "❌ Could not find frameworks in archives"
    echo "iOS Framework: $IOS_FRAMEWORK"
    echo "Simulator Framework: $SIM_FRAMEWORK"
    echo ""
    echo "Full archive structure:"
    echo "iOS Device:"
    ls -la "$ARCHIVE_DIR/ios_devices.xcarchive/" 2>/dev/null || echo "Archive not found"
    echo "iOS Simulator:"
    ls -la "$ARCHIVE_DIR/ios_sim.xcarchive/" 2>/dev/null || echo "Archive not found"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "🧱 Creating XCFramework..."
echo "Using iOS framework: $IOS_FRAMEWORK"
echo "Using Simulator framework: $SIM_FRAMEWORK"

xcodebuild -create-xcframework \
  -framework "$IOS_FRAMEWORK" \
  -framework "$SIM_FRAMEWORK" \
  -output "$XCFRAMEWORK_OUTPUT"

echo
echo "✅ XCFramework created at:"
echo "$XCFRAMEWORK_OUTPUT"

# Copy the XCFramework to the package directory
FINAL_OUTPUT="$PACKAGE_ABS_PATH/${OUTPUT_NAME}.xcframework"
cp -R "$XCFRAMEWORK_OUTPUT" "$FINAL_OUTPUT"
echo "📦 XCFramework copied to: $FINAL_OUTPUT"

# Cleanup
echo "🧹 Cleaning up temporary files..."
rm -rf "$TMP_DIR"

echo "🎉 Done!"
