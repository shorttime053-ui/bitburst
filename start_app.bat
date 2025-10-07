@echo off
echo.
echo ========================================
echo    PitchUp Application Launcher
echo ========================================
echo.
echo Starting PitchUp Sports Turf Booking Platform...
echo.

cd /d "%~dp0"

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev
    pause
    exit /b 1
)

echo.
echo Installing dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Running tests...
flutter test
if %errorlevel% neq 0 (
    echo WARNING: Some tests failed, but continuing...
)

echo.
echo Starting PitchUp application...
echo Application will be available at: http://localhost:8080
echo.
echo Press Ctrl+C to stop the application
echo.

flutter run -d web-server --web-port 8080

echo.
echo PitchUp application stopped.
pause
