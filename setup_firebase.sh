#!/bin/bash

# Add pub-cache to PATH temporarily and run flutterfire configure
export PATH="$PATH:$HOME/.pub-cache/bin"

echo "Running flutterfire configure..."
flutterfire configure --project=asha-triage

echo ""
echo "✅ Firebase configuration complete!"
echo "Next steps:"
echo "1. Run: flutter pub get"
echo "2. Run: flutter build web"
echo "3. Run: firebase deploy --only hosting"
