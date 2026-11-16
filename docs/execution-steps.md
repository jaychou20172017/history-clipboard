[English](en/execution-steps.md)

# 分阶段执行步骤 — 历史粘贴板

> 版本: v1.0 | 日期: 2026-07-02

---

## 阶段总览

```
阶段 1 → 阶段 2 → 阶段 3 → 阶段 4 → 阶段 5
骨架数据   监听捕获   界面展示   交互功能   设置收尾
```

每个阶段完成后，必须通过验证才能进入下一阶段。

---

## 阶段 1：项目骨架 & 数据层

> 目标：Xcode 项目能跑起来，数据能存能读

### 任务清单

- [ ] 创建 Xcode macOS App 项目（SwiftUI App 模板）
- [ ] 创建 Models/ClipboardItem.swift — 数据模型
- [ ] 创建 Models/ClipboardStore.swift — 增删改查 + JSON 持久化
- [ ] 创建 Utils/ImageHelper.swift — 图片保存/读取/缩略图
- [ ] 在 App 入口中实例化 Store，写入测试数据，验证读写

### 验证方法

1. 运行 App，确认无崩溃
2. 代码调用 Store 写入一条文字记录
3. 检查 `~/Library/Application Support/ClipboardHistory/items.json` 文件生成
4. 读取、删除操作正常

### 产出文件

- `ClipboardHistory/ClipboardHistoryApp.swift`
- `ClipboardHistory/Models/ClipboardItem.swift`
- `ClipboardHistory/Models/ClipboardStore.swift`
- `ClipboardHistory/Utils/ImageHelper.swift`

---

## 阶段 2：剪贴板监听

> 目标：自动捕获系统复制操作

### 任务清单

- [ ] 创建 Services/ClipboardMonitor.swift — NSPasteboard 轮询
- [ ] 区分文字类型和图片类型
- [ ] 去重逻辑：changeCount 判断 + 内容比对
- [ ] 连接 ClipboardMonitor 输出到 ClipboardStore
- [ ] 实现暂停/恢复监听方法
- [ ] 在 App 入口启动 ClipboardMonitor

### 验证方法

1. 启动 App
2. 在任意地方复制文字 → 检查 items.json 有新增
3. 复制图片 → 检查 images/ 目录有新增图片文件
4. 重复复制相同内容 → 确认不会产生重复记录

### 产出文件

- `ClipboardHistory/Services/ClipboardMonitor.swift`

---

## 阶段 3：菜单栏 & 主界面

> 目标：菜单栏图标 + 弹出面板 + 卡片列表

### 任务清单

- [ ] 创建 Views/MenuBarController.swift — NSStatusBar + NSPopover
- [ ] 创建 Views/ContentListView.swift — 搜索框 + 卡片列表
- [ ] 创建 Views/ClipboardCard.swift — 单条卡片视图
- [ ] 空状态视图（暂无复制历史）
- [ ] 面板弹出时暂停监听，收起时恢复监听
- [ ] 在 App 入口启动 MenuBarController

### 验证方法

1. 启动 App → 菜单栏出现图标
2. 点击图标 → 面板弹出
3. 复制内容 → 面板中出现卡片
4. 点击面板外区域 → 面板收起
5. 空列表 → 显示空状态

### 产出文件

- `ClipboardHistory/Views/MenuBarController.swift`
- `ClipboardHistory/Views/ContentListView.swift`
- `ClipboardHistory/Views/ClipboardCard.swift`

---

## 阶段 4：交互功能

> 目标：搜索、置顶、删除、点击复制

### 任务清单

- [ ] 搜索框输入实时过滤列表
- [ ] 删除按钮 → 从 Store 移除数据
- [ ] 置顶按钮 → 切换 isPinned，列表重排
- [ ] 点击卡片 → 内容写入剪贴板 → 面板收起
- [ ] 面板收起时清空搜索内容

### 验证方法

1. 输入文字 → 列表实时过滤
2. 删除一条记录 → 消失，刷新 items.json
3. 置顶 → 卡片移到最上方
4. 点击卡片 → 到任意处 Cmd+V → 内容正确粘贴
5. 重新打开面板 → 搜索框已清空

---

## 阶段 5：设置 & 清理 & 适配

> 目标：留存设置、自动清理、深浅色适配

### 任务清单

- [ ] 创建 Views/SettingsView.swift — 留存天数分段选择器
- [ ] 创建 Services/CleanupService.swift — 定时清理过期数据
- [ ] 在 App 入口启动 CleanupService
- [ ] 验证深色/浅色模式下 UI 显示正常
- [ ] 菜单栏图标在深浅色模式下的适配
- [ ] 整体走查，修边角问题

### 验证方法

1. 切换留存天数为 1 天 → 确认过期内容被清理
2. 系统切换深色/浅色模式 → 面板 UI 自动适配
3. 完整流程走查：复制→查看→搜索→置顶→删除→清理

### 产出文件

- `ClipboardHistory/Views/SettingsView.swift`
- `ClipboardHistory/Services/CleanupService.swift`

---

## 完成标准

- [ ] 所有 P0、P1、P2 功能正常工作
- [ ] 深浅色模式 UI 正确
- [ ] 留存清理正常执行
- [ ] 菜单栏图标正常显示
- [ ] 无崩溃、无内存泄漏
