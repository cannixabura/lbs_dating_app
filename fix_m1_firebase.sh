#!/bin/bash
echo "🔧 程式夥伴啟動：開始修復 M1 Mac Firebase 環境..."

# 1. 透過 Homebrew 安裝 Node.js (完美支援 M1)
echo "📦 正在安裝 Node.js..."
brew install node

# 2. 透過 npm 全域安裝 Firebase CLI 工具
echo "🔥 正在安裝原生 Firebase CLI..."
npm install -g firebase-tools

# 3. 解決 flutterfire 路徑找不到的問題
echo "⚙️ 設定環境變數路徑..."
export PATH="$PATH":"$HOME/.pub-cache/bin"

# 4. 登入 Firebase
echo "👉 準備登入 Firebase，請在瀏覽器中授權："
firebase login

# 5. 重新啟動 Flutter 專案的 Firebase 配置
echo "⚡ 啟動 FlutterFire 配置..."
flutterfire configure
