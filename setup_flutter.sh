#!/bin/bash
set -e

echo "Installing Flutter SDK..."

# Install dependencies
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Download Flutter SDK
cd ~
if [ ! -d "flutter" ]; then
    echo "Downloading Flutter SDK..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# Add Flutter to PATH
export PATH="$HOME/flutter/bin:$PATH"

# Add to .bashrc for persistence
if ! grep -q "flutter/bin" ~/.bashrc; then
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
fi

# Run Flutter doctor
flutter doctor

echo ""
echo "Flutter installed! Run 'source ~/.bashrc' or restart terminal, then:"
echo "  cd /workspaces/AI-PulseTriage-ASHA-Enabled-Risk-Screening"
echo "  flutter pub get"
echo "  flutter gen-l10n"
echo "  flutter run -d chrome"
