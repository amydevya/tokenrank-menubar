#!/bin/bash
# tokenrank-menubar 一键安装
set -e
cd "$(dirname "$0")"

echo "==> 检查依赖"
if ! command -v brew >/dev/null 2>&1; then
  echo "!! 需要 Homebrew: https://brew.sh"; exit 1
fi
if [ ! -d "/Applications/SwiftBar.app" ]; then
  echo "==> 安装 SwiftBar"
  brew install --cask swiftbar
fi
if ! python3 -c "import PIL" >/dev/null 2>&1; then
  echo "==> 安装 Pillow"
  pip3 install --user pillow || pip3 install --user --break-system-packages pillow
fi

echo "==> 安装脚本"
mkdir -p "$HOME/.local/bin"
cp tokenrank-menubar "$HOME/.local/bin/tokenrank-menubar"
chmod +x "$HOME/.local/bin/tokenrank-menubar"

echo "==> 注册 SwiftBar 插件"
PLUGDIR="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || true)"
if [ -z "$PLUGDIR" ]; then
  PLUGDIR="$HOME/.swiftbar-plugins"
  defaults write com.ameba.SwiftBar PluginDirectory "$PLUGDIR"
fi
mkdir -p "$PLUGDIR"
ln -sf "$HOME/.local/bin/tokenrank-menubar" "$PLUGDIR/tokenrank.60s.py"
echo "    插件目录: $PLUGDIR"

echo "==> 设置开机自启"
osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null | grep -q SwiftBar || \
  osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/SwiftBar.app", hidden:false}' >/dev/null 2>&1 || true

echo "==> 启动"
open -a SwiftBar
echo ""
echo "✓ 完成！菜单栏几秒后出现 Token 面板。"
echo "  · Claude 额度首次读取会弹 Keychain 授权 → 点「始终允许」"
echo "  · 终端可用: tokenrank-menubar（状态总览）/ tokenrank-menubar start（拉起组件）"
