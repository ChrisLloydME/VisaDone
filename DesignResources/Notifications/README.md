# 通知中心 · Telegram 当前 macOS 界面

基准是 **TelegramMessenger/telegram-macos**，不是旧版 `TelegramOrg/Telegram-macos-Swift` 镜像。

- 上游：https://github.com/TelegramMessenger/telegram-macos
- 读取版本：`e18830989542a063dd66c5bdc4dbe6a70cbbd175`
- 许可证：GPL-2.0，见 `Licenses/Telegram-GPL-2.0.txt`。
- 对照截图：用户提供的新版 Telegram，悬浮玻璃会话头、独立工具胶囊、底部三段式悬浮输入栏。

## 实际代码复用与适配

原始文件保存在 `TelegramSource/`，不参与编译：

1. `ChatMessageBubbleImages.swift`：从当前官方 `packages/TelegramTheme` 移植完整气泡形状、16/8pt 主/连接圆角、尾部绘制、连续消息分类、遮罩和九宫格拉伸。可编译版本是 `VisaDone/TelegramUI/TelegramBubbleImage.swift`。只移除未使用的 ImageCorners 转换接口，并以 Core Graphics 替换 TGUIKit 的图像辅助函数、以本地 2× 比例替换全局 System 状态。
2. `LiquidGlassView.swift` 与 `FlippedGlassEffectContainerView.swift`：抽取 macOS 的 `NSGlassEffectView` / `NSGlassEffectContainerView` 实现，适配为 `TelegramGlassSurface` 和 `TelegramGlassGroup`。沿用原生 regular glass、圆角配置、翻转坐标和共享容器；不引入 Telegram 的旧系统 fallback、私有 selector 或自定义模拟玻璃。
3. `ChatHeaderBubblesView.swift`：沿用会话信息和搜索/更多两个独立玻璃胶囊、12pt 边距、8pt 胶囊间距、头像位于信息胶囊左侧的结构。会话头按桌面尺度收紧到 36pt、头像 28pt，保留双行中文信息。
4. `ChatInputView.swift`：沿用附件、文字、发送三个玻璃槽位，共享 5pt spacing 的原生玻璃容器。整栏悬浮在消息之上，底部留 12pt；没有固定底栏背景或分隔线。
