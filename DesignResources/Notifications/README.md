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
## iMessage 会话侧栏

侧栏以用户提供的 iMessage 截图为基准，使用 macOS 27 的 `NSTableView.Style.sourceList` 和原生行选择。侧栏及消息区不另铺底色，共同透出其他页面使用的窗口 AppKit `.sidebar` 语义材质（`.behindWindow` 混合）。不使用 Telegram 自绘的选中背景或仿 macOS 26 的 sidebar。

行高 72pt，36pt 头像，13pt semibold 姓名，11pt 次要时间，12.5pt regular 两行摘要。系统 source-list 内缩配合行内坐标，使头像和文字分别对齐 iMessage 的约 26 / 72pt 位置。分隔线从文字起点延伸。未读使用小圆点，而不是 Telegram 的数字胶囊。

顶部只保留 NSGlassEffectView 承载的无边框原生 NSSearchField，由系统提供真实 Liquid Glass 搜索外观；编辑、清除和搜索菜单仍由 NSSearchField 处理。「全部标为已读」通过搜索菜单提供。侧栏底部用悬浮的原生玻璃容器承载「消息 / 评论」两个图标加文字入口；系统通知归入消息。外层为原生 NSGlassEffectView，内部只有一个轻量选中指示区，按钮不单独绘制边框或玻璃背景，点击直接筛选对应会话。iMessage 是闭源应用，此处没有声称复用其源码；实际复用的是 AppKit 系统侧栏控件。

## 项目内的边界

`NotificationsView.swift` 仅通过 NSViewControllerRepresentable 承载 AppKit 页面，沿用现有帖子详情和文件预览 Sheet。消息页的分栏、列表、搜索、文本输入和消息绘制使用 AppKit；评论详情以 NSHostingView 嵌入独立的 SwiftUI 讨论阅读界面。

所有会话、文档和状态是本地虚构 sample，不接 Telegram 或其他后端。Return 发送、Shift–Return 换行；中文输入法确认候选时不触发发送。附件菜单分享预设的脱敏行程文档。

消息列表沿用项目的系统 Accent Color、Light / Dark Appearance、头像和未修改的风景原图。原生玻璃需要真实窗口合成；离屏预览只用于核对几何尺寸、文本、气泡与两种外观下的可读性，不能代替真实窗口中的玻璃效果验收。

搜索框是侧栏上的独立悬浮玻璃层。会话 ScrollView 覆盖整个侧栏直达 Toolbar 下沿；60pt 初始间距位于可滚动文档内，消息上滚时经过搜索框后方，不会在搜索框底部裁切。

底部分类栏高 48pt、最大宽 224pt、底部间距 12pt；图标和标题采用固定分离的原生 NSButtonCell 布局。列表文档底部留 72pt 可滚动间距，使最后一条会话可完整停在 Tab Bar 上方，滚动区域仍覆盖整个侧栏。默认进入消息分类。

Flighty 的已安装 macOS 程序链接 UIKit/Mac Catalyst 并引用 UITabBarController；仅凭这些依赖不能断言截图中的具体栏是否自绘。VisaDone 按用户选择保留 AppKit，当前分类栏不是 UIKit UITabBar，不将其称为 iOS 原生 Tab Bar。

搜索、会话头、聊天输入区统一为 36pt 高；操作图标 16–17pt、输入文字 13pt，消息正文 14pt，消息时间 11pt。功能区两侧和底部统一 12pt 留白。消息分类使用 person.fill。样例扩充至 24 条会话，包含多轮材料讨论、行程协作与递交进度交流；系统消息仍归在「消息」中。

搜索顶部使用 NSSplitViewItemAccessoryViewController 注册 accessory，并设置 preferredScrollEdgeEffectStyle = .soft。通知中心内部采用原生 NSSplitViewController 以建立系统 accessory 与滚动内容的关系；不使用渐变遮罩或额外 NSVisualEffectView 模拟边缘效果。会话滚动范围仍延伸到顶部。

尺寸常量集中在 NativeNotificationCenter.swift 的 InboxMetrics：36pt 单行功能控件、48pt 双行导航、72pt 会话行、60pt 顶部 accessory。消息内容和系统玻璃材质继续复用，不更换页面背景或主窗口 Toolbar。

## 评论讨论（重新设计）

评论不再复用 Telegram 私信气泡与输入工具。保留 AppKit 分栏、原生侧栏选择、顶部搜索和底部分类入口；评论预览行高 94pt，依次展示评论者、最近回复和原帖标题。搜索可匹配回复正文及原帖标题。

右侧以 720pt 最大阅读宽度展示原帖摘要、根评论和完整回复。所有作者同侧排列，按时间从根部展开，用最多两级缩进、轻连接线、回复对象标注表达关系。首次进入从顶部阅读，不定位到最新消息。帖子入口复用原项目详情 Sheet，头像复用现有 AuthorAvatarView。点赞、指定回复、回复草稿和新增回复全部为本地状态；输入框显示当前回复对象，发布后滚动到新回复。外层没有额外底色，底部使用系统 glassEffect 和原生 soft scroll-edge treatment。

复用调研对照了 IceCubesApp 的 StatusKit 目录和 SwiftyComments 的层级评论方案；本次优先复用当前项目已有的界面组件，避免引入另一套应用页面或 UIKit 组件。此次保留项目现成分栏、头像、帖子详情、素材和系统滚动控件，仅新增本地讨论模型与阅读布局，没有复制这两个项目的代码。

全局窗口背景现由 `VisaDoneApp.swift` 的 `WindowSidebarMaterial` 提供。应用户的整窗统一毛玻璃要求，将公开的 NSVisualEffectView `.sidebar` 语义材质用于整个窗口背景，并以 `.behindWindow` 混合桌面及后方窗口；状态使用 `.followsWindowActiveState`。这是主动将 AppKit 的 Sidebar 材质扩展到整窗，不声称等同于新版 NSSplitViewController 私有的 Sidebar 玻璃呈现。SwiftUI 窗口底色清空，背景视图延伸至 titlebar 安全区，内容面板保持透明，避免原来的 thickMaterial 与新背景重复叠加。现有 Toolbar 和交互控件各自的原生玻璃、滚动边缘效果继续保留。
