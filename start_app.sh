#!/bin/bash

echo ""
echo "========================================"
echo "   PitchUp Application Launcher"
echo "========================================"
echo ""
echo "Starting PitchUp Sports Turf Booking Platform..."
echo ""

# Change to script directory
cd "$(dirname "$0")"

echo "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "ERROR: Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

flutter --version

echo ""
echo "Installing dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install dependencies"
    exit 1
fi

echo ""
echo "Running tests..."
flutter test
if [ $? -ne 0 ]; then
    echo "WARNING: Some tests failed, but continuing..."
fi

echo ""
echo "Starting PitchUp application..."
echo "Application will be available at: http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop the application"
echo ""

flutter run -d web-server --web-port 8080

echo ""
echo "PitchUp application stopped."
