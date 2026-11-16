[English](CLAUDE.en.md)

# CLAUDE.md — 历史粘贴板项目指引

## 项目概述

开发一款运行在 macOS 上的菜单栏历史粘贴板工具。自动记录用户复制的文字和图片，以时间降序卡片形式展示，支持搜索、置顶、删除，可设置 1/3/5 天留存自动清理。

## 标准文档路径

| 文档 | 路径 | 说明 |
|------|------|------|
| 产品需求 | [docs/requirements.md](docs/requirements.md) | 功能清单、优先级、状态 |
| 技术规格 | [docs/tech-spec.md](docs/tech-spec.md) | 技术选型、架构、存储方案 |
| 设计规范 | [docs/design-guidelines.md](docs/design-guidelines.md) | UI 尺寸、颜色、交互定义 |
| 执行步骤 | [docs/execution-steps.md](docs/execution-steps.md) | 分阶段任务清单 |
| 开发日志 | [dev-log/](dev-log/) | 每日开发记录 |

## 工作原则

1. **严格按阶段推进** — 执行步骤以 [docs/execution-steps.md](docs/execution-steps.md) 为准，完成一个阶段并验证通过后再进入下一阶段
2. **每阶段必验证** — 不要跳过验证直接进入下一阶段
3. **每日写日志** — 每天开发结束后，在 [dev-log/](dev-log/) 下生成 `YYYY-MM-DD.md` 日志文件
4. **需求变更先更新文档** — 修改需求前先更新 [docs/requirements.md](docs/requirements.md)
5. **简单优先** — 不引入不必要的抽象和第三方依赖，能简单实现就不复杂化
6. **一次只做一个阶段** — 不要一口气做完所有代码，每完成一个阶段停下来让用户确认

## 关键路径

| 路径 | 说明 |
|------|------|
| `/Users/jiezhou/Documents/AI/历史粘贴板/` | 项目根目录 |
| `ClipboardHistory/` | Xcode 项目目录 |
| `~/Library/Application Support/ClipboardHistory/` | 运行时数据存储 |

## 技术概要

- 语言：Swift 5.9+
- UI：SwiftUI + AppKit 混合
- 菜单栏：NSStatusBar + NSPopover
- 剪贴板：NSPasteboard 轮询（0.5s 间隔）
- 存储：JSON + 文件系统
- 最低系统：macOS 14 Sonoma

## 当前阶段

**全部 5 阶段已完成 ✅** — 可用版本

- [x] 阶段 1：项目骨架 & 数据层
- [x] 阶段 2：剪贴板监听
- [x] 阶段 3：菜单栏 & 主界面
- [x] 阶段 4：交互功能
- [x] 阶段 5：设置 & 清理 & 适配
