[English](en/tech-spec.md)

# 技术规格文档 — 历史粘贴板

> 版本: v1.0 | 日期: 2026-07-02

---

## 技术栈

| 分类 | 选择 | 说明 |
|------|------|------|
| 语言 | Swift 5.9+ | Apple 官方语言 |
| UI 框架 | SwiftUI + AppKit 混合 | SwiftUI 做界面，AppKit 做菜单栏托管 |
| 菜单栏 | NSStatusBar + NSPopover | 原生菜单栏集成 |
| 剪贴板 | NSPasteboard | 系统剪贴板 API，0.5s 轮询 |
| 存储 | Codable JSON + 文件系统 | 元数据 JSON 序列化，图片以文件存储 |
| 依赖管理 | 无第三方依赖 | 纯 Apple 框架实现 |
| 最低系统 | macOS 14 Sonoma | |

---

## 项目结构

```
ClipboardHistory/
├── ClipboardHistoryApp.swift          # @main 入口
├── Models/
│   ├── ClipboardItem.swift            # 数据模型
│   └── ClipboardStore.swift           # 数据持久化管理
├── Services/
│   ├── ClipboardMonitor.swift         # 剪贴板监听
│   └── CleanupService.swift           # 过期清理
├── Views/
│   ├── MenuBarController.swift        # 菜单栏控制器
│   ├── ContentListView.swift          # 主列表视图
│   ├── ClipboardCard.swift            # 单条卡片
│   └── SettingsView.swift             # 留存设置
├── Utils/
│   └── ImageHelper.swift              # 图片工具
└── Assets.xcassets                    # 资源文件
```

---

## 数据模型

```swift
struct ClipboardItem: Identifiable, Codable, Equatable {
    let id: UUID
    let type: ItemType
    var textContent: String?
    var imageFileName: String?
    let timestamp: Date
    var isPinned: Bool
}

enum ItemType: String, Codable {
    case text
    case image
}
```

---

## 存储方案

### 存储路径
```
~/Library/Application Support/ClipboardHistory/
├── items.json        # 所有记录元数据（JSON 数组）
└── images/           # 图片文件（UUID 命名）
    ├── abc-123.png
    └── def-456.jpg
```

### items.json 结构
```json
[
  {
    "id": "uuid-string",
    "type": "text",
    "textContent": "复制的内容...",
    "timestamp": "2026-07-02T12:00:00Z",
    "isPinned": false
  },
  {
    "id": "uuid-string-2",
    "type": "image",
    "textContent": null,
    "imageFileName": "uuid-string-2.png",
    "timestamp": "2026-07-02T12:01:00Z",
    "isPinned": true
  }
]
```

### 用户设置
使用 `@AppStorage` 存储，自动由 UserDefaults 管理：
- `retentionDays`: Int，默认 3

---

## 组件职责

### ClipboardHistoryApp（入口）
- `@main` 应用入口
- 初始化 ClipboardStore、ClipboardMonitor
- 创建 MenuBarController
- 启动 CleanupService 定时任务

### ClipboardStore（数据层）
- 从 items.json 加载数据到内存
- 提供增删改查方法
- 每次变更后自动写回 JSON 文件
- 图片通过 ImageHelper 读写
- `@Published` 属性驱动 UI 更新

### ClipboardMonitor（监听层）
- 启动 Timer，每 0.5s 检查 NSPasteboard.general
- 通过 changeCount 判断是否有新内容
- 区分文字类型（.string）和图片类型（.tiff）
- 去重：相同内容不重复写入
- 可暂停/恢复（面板打开时暂停）

### MenuBarController（菜单栏）
- 创建 NSStatusBar 图标
- 图标点击事件切换 NSPopover 显隐
- NSPopover 内托管 SwiftUI ContentListView
- 面板弹出时暂停 ClipboardMonitor，收起时恢复

### Views（视图层）
- ContentListView：搜索框 + ScrollView 卡片列表 + 空状态
- ClipboardCard：内容预览、时间标签、置顶/删除按钮
- SettingsView：留存天数分段选择器

### CleanupService
- 启动时运行一次清理
- 之后每隔 10 分钟检查
- 删除超过 retentionDays 天的非置顶记录
- 清理关联的图片文件

---

## 关键约束

- **无第三方依赖**：只用 Apple 框架
- **无网络权限**：不请求任何网络访问
- **沙盒模式**：遵循 macOS App Sandbox
- **内存管理**：图片列表使用缩略图，不加载原图到列表
