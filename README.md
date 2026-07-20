# tokenrank-menubar

Mac 菜单栏的 AI Token 用量/额度面板（SwiftBar 插件）。一眼看到：

- **今日用量**（tokenrank 口径：新鲜 input + output，不含缓存）+ 分工具明细
- **生财 Token 排行榜排名**（可选，需生财有术社群 opentoken）
- **成本**（今日/本月，来自 Token Monitor，可选）
- **Claude / Codex 官方额度**：5h 与 weekly 用量百分比 + 重置倒计时
- **近 7 天用量趋势图**：按工具堆叠、品牌配色、坐标轴刻度

面板为 Pillow 实时渲染的透明图片——不受 macOS 菜单磨砂淡化影响，深/浅色模式自动适配。

## 数据源与隐私

**全部本地直连，无任何第三方上传**：

| 数据 | 来源 | 需要什么 |
|---|---|---|
| 用量/趋势 | `opentoken preview`（扫描本地日志） | [opentoken](https://scys.com/tokenrank)（生财有术社群工具） |
| Codex 额度 | `~/.codex/sessions` 里 Codex 自己记录的 rate_limits | 本地用过 Codex CLI 即可，零鉴权 |
| Claude 额度 | 本机 Keychain 凭证 → Anthropic 官方 `oauth/usage` 接口 | Claude Code 登录态（首次弹 Keychain 授权，选"始终允许"） |
| 成本 | Token Monitor 的本地缓存文件 | [Token Monitor](https://github.com/Javis603/token-monitor)（可选） |
| 排名 | scys.com 排行榜 API | 生财 user_id（可选） |

**缺哪个就少显示哪块，其余功能不受影响。** 比如没有 opentoken 也能当纯 Claude/Codex 额度监控用。

## 安装

```bash
git clone https://github.com/<你的用户名>/tokenrank-menubar.git
cd tokenrank-menubar
./install.sh
```

或手动：

```bash
# 1. 依赖
brew install --cask swiftbar
pip3 install --user pillow

# 2. 安装脚本 + 注册为 SwiftBar 插件（文件名里的 60s = 刷新间隔）
mkdir -p ~/.local/bin ~/.swiftbar-plugins
cp tokenrank-menubar ~/.local/bin/ && chmod +x ~/.local/bin/tokenrank-menubar
ln -sf ~/.local/bin/tokenrank-menubar ~/.swiftbar-plugins/tokenrank.60s.py
defaults write com.ameba.SwiftBar PluginDirectory "$HOME/.swiftbar-plugins"

# 3. 启动
open -a SwiftBar
```

> 注意：如果你已在用 SwiftBar，第 2 步的 `defaults write` 会改插件目录——请改为把软链放进你现有的插件目录。

## 终端用法

```bash
tokenrank-menubar          # 人类可读的状态总览
tokenrank-menubar start    # 拉起菜单栏组件（=启动 SwiftBar）
```

## 自定义

- **刷新间隔**：重命名软链，如 `tokenrank.30s.py` / `tokenrank.5m.py`
- **额度告警阈值**：脚本头部 `SEV`（默认 ≥60% 黄、≥85% 红）
- **工具品牌色**：脚本头部 `TOOL_COLORS`
- **面板宽度**：`PANEL_W`（默认 300pt）

## 卸载

```bash
rm ~/.swiftbar-plugins/tokenrank.60s.py ~/.local/bin/tokenrank-menubar
rm -rf ~/.cache/tokenrank-menubar
```

## 已知限制

- 仅 macOS（依赖 SwiftBar / Keychain / sips）
- 中文字体按 PingFang（系统或飞书副本）→ Hiragino → 黑体顺序探测；都没有会退化为默认字体
- Claude 额度接口有限流，脚本内置 5 分钟缓存 + 失败退避，限流期间显示上次数据
- macOS 菜单一行只能绑一个点击动作（NSMenu 限制），故刷新在顶部条、排行榜在底部行

## License

MIT
