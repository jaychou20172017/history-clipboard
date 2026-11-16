# Requirements

[中文](../requirements.md)

A macOS menu-bar history tool captures copied text/images locally and shows newest-first cards. P0: clipboard monitoring, reverse-time list, menu icon/popover, click-to-copy-back followed by manual Cmd+V, local-only storage. P1: live text search, single deletion, pinning, 1/3/5-day retention and light/dark support. P2: image thumbnails. Global hotkeys, tags and a separate favorites area remain future discussions in the source requirement, not implemented claims.

Documented targets: popover latency under 200 ms, background memory under 50 MB, smooth scrolling and macOS 14+. These are targets, not measurements from this documentation update. SwiftUI/AppKit native UI, no network/cloud data storage. Preserve historical status/date in the Chinese source instead of treating its unchecked plan as current testing evidence.
