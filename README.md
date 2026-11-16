中文 | [English](README.en.md)

history-clipboard是一款轻量级的 macOS 剪贴板历史管理工具，帮助你保存所有复制过的文本、图片等数据，并按设定的保留期限（1天、3天、5天）自动清理过期内容。你可以随时从历史列表中点击任意条目，将其重新复制到剪贴板，方便重复使用。

功能特性

自动记录：后台监听系统剪贴板，自动保存复制的内容（支持文本、图片、文件路径等）。
保留策略：可设置保留时长（1天 / 3天 / 5天），过期条目自动清除，节省存储空间。
快捷检索：内置搜索框，支持按关键字快速筛选历史条目。
一键重用：点击任意历史条目，立即将其复制到当前剪贴板，粘贴即用。
轻量原生：使用 Swift + SwiftUI 开发，完美适配 macOS 风格，资源占用极低。

使用说明

启动应用：首次启动后，应用将驻留在菜单栏（图标为 📋），点击图标可展开主窗口。
查看历史：所有复制过的内容会按时间倒序显示在列表中。
设置保留时长：点击窗口下方的 “保留” 按钮，选择 1天、3天或5天（默认为3天）。
搜索条目：在顶部搜索框中输入关键词，列表将实时过滤。
重新复制：双击或单击条目（取决于设置），该内容会被重新写入系统剪贴板，你可以在任意应用中粘贴（⌘V）。

history-clipboard is a lightweight macOS clipboard history management tool that helps you save all copied text, images, and other data, and automatically clears expired items based on a retention period you set (1 day, 3 days, or 5 days). You can click any history item at any time to copy it back to the clipboard for reuse.

Features

Automatic Recording: Monitors the system clipboard in the background and automatically saves copied content (supports text, images, file paths, etc.).
Retention Policy: Set a retention period (1 day / 3 days / 5 days) – expired items are automatically removed to save storage space.
Quick Search: Built‑in search box lets you filter history items by keyword in real time.
One‑Click Reuse: Click any history item to immediately copy it back to the current clipboard, ready to paste anywhere.
Lightweight & Native: Built with Swift and SwiftUI, perfectly adapted to the macOS style, with minimal resource usage.

How to Use

Launch the App: On first launch, the app resides in the menu bar (icon: 📋). Click the icon to open the main window.
View History: All copied items are displayed in reverse chronological order in the list.
Set Retention Period: Click the “Retention” button at the bottom of the window and choose 1 day, 3 days, or 5 days (default is 3 days).
Search Entries: Type keywords into the search box at the top, and the list will filter in real time.
Recopy: Double‑click or single‑click an entry (depending on your settings) – the content is written back to the system clipboard, and you can paste it (⌘V) in any application.


## 许可 / License

Copyright (c) 2026 Zhou Jie。非商业用途及企业内部使用免费；对外销售、收费服务、商业产品集成及商业托管等须事先取得书面授权。联系：[3504264104@qq.com](mailto:3504264104@qq.com)。

Noncommercial and internal business use are free. External sales, paid services, commercial product integration and commercial hosting require prior written authorization from Zhou Jie.

完整条款 / Full terms: [LICENSE](LICENSE). [English translation](LICENSE.en.md)（中文准据 / Chinese governs）. [商业授权 / Commercial licensing](COMMERCIAL-LICENSE.md).

本许可仅覆盖权利人有权许可的项目内容，不改变第三方组件许可。新增许可不追溯撤销先前已合法取得的其他许可；历史发布包不会自动更新。This license does not replace third-party terms or revoke earlier lawfully granted rights; old release archives are not automatically updated.
