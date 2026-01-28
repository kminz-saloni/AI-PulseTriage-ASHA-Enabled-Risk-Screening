#!/bin/bash

echo "🔧 Cleaning and rebuilding the Flutter app..."
echo ""

# Clean previous builds
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for web
echo "🏗️  Building for web..."
flutter build web

# Deploy to Firebase
if [ $? -eq 0 ]; then
    echo ""
    echo "🚀 Deploying to Firebase Hosting..."
    firebase deploy --only hosting
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Deployment successful!"
        echo "🌐 Your app is live at: https://asha-triage.web.app"
    fi
else
    echo ""
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi
