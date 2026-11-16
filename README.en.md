# history-clipboard
[中文 / existing bilingual introduction](README.md) | English

A lightweight native macOS menu-bar clipboard history tool using Swift/SwiftUI and AppKit. Record copied text and images locally, search history, pin or delete entries, and copy an entry back for manual Cmd+V pasting. There is no cloud synchronization.

## Usage
Launch the app and click its menu-bar icon to open history. Entries are shown newest first, with pinned entries above others. Use search to filter text; click a card to copy it back to the clipboard. Choose a retention period of 1, 3 or 5 days (default 3). Expired unpinned entries and associated image files are cleaned up.

## Development and privacy
The documented target is macOS 14 Sonoma or later and Swift 5.9+. Open `ClipboardHistory.xcodeproj` in Xcode. The implementation uses Apple frameworks with no third-party dependencies. Data is stored in `~/Library/Application Support/ClipboardHistory/` as JSON metadata and image files. Clipboard history may contain sensitive information; protect access to that local data.

See [English documentation](docs/en/index.md) for requirements, technical architecture, design and staged verification. The Chinese historical execution checklist and developer log remain available as records; they are not new test results. Documentation is bilingual; application UI localization is outside this update.
## 许可 / License

Copyright (c) 2026 Zhou Jie。非商业用途及企业内部使用免费；对外销售、收费服务、商业产品集成及商业托管等须事先取得书面授权。联系：[3504264104@qq.com](mailto:3504264104@qq.com)。

Noncommercial and internal business use are free. External sales, paid services, commercial product integration and commercial hosting require prior written authorization from Zhou Jie.

完整条款 / Full terms: [LICENSE](LICENSE). [English translation](LICENSE.en.md)（中文准据 / Chinese governs）. [商业授权 / Commercial licensing](COMMERCIAL-LICENSE.md).

本许可仅覆盖权利人有权许可的项目内容，不改变第三方组件许可。新增许可不追溯撤销先前已合法取得的其他许可；历史发布包不会自动更新。This license does not replace third-party terms or revoke earlier lawfully granted rights; old release archives are not automatically updated.
