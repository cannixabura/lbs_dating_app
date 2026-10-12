#!/bin/bash
echo "🔧 程式夥伴啟動：開始自動配置權限與 Firebase CLI..."

# 1. 自動寫入 iOS 定位權限
PLIST_FILE="ios/Runner/Info.plist"
if [ -f "$PLIST_FILE" ]; then
    echo "🍎 正在寫入 iOS 定位權限..."
    /usr/libexec/PlistBuddy -c "Add :NSLocationWhenInUseUsageDescription string '為了在街上看到附近的朋友，我們需要精準定位。'" "$PLIST_FILE" 2>/dev/null || echo "⚠️ iOS 權限已存在"
    /usr/libexec/PlistBuddy -c "Add :NSLocationAlwaysUsageDescription string '為了隨時同步你的狀態給附近的人，我們需要精準定位。'" "$PLIST_FILE" 2>/dev/null || echo "⚠️ iOS 權限已存在"
fi

# 2. 自動寫入 Android 定位權限
ANDROID_MANIFEST="android/app/src/main/AndroidManifest.xml"
if [ -f "$ANDROID_MANIFEST" ]; then
    echo "🤖 正在寫入 Android 定位權限..."
    if grep -q "ACCESS_FINE_LOCATION" "$ANDROID_MANIFEST"; then
        echo "⚠️ Android 定位權限已存在"
    else
        sed -i '' '/<manifest/a\
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />\
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />\
' "$ANDROID_MANIFEST"
    fi
fi

# 3. 安裝 Firebase 相關工具
echo "🚀 正在下載並安裝 Firebase CLI 工具 (如果提示輸入密碼，請輸入你的 Mac 開機密碼)..."
curl -sL https://firebase.tools | bash

echo "👉 接下來會打開瀏覽器，請登入你的 Google 帳號："
firebase login

echo "⚡ 啟動 FlutterFire 配置..."
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"

echo "🎉 準備就緒！請在下方列表中，使用鍵盤上下鍵選擇你建立的 Firebase 專案，然後按 Enter："
flutterfire configure
