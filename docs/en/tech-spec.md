# Tech Spec

[中文](../tech-spec.md)

Swift 5.9+, SwiftUI/AppKit, NSStatusBar/NSPopover and NSPasteboard; macOS 14+. No third-party dependencies or network requests. Codable JSON stores metadata; images are files under `~/Library/Application Support/ClipboardHistory/images/`, with metadata in items.json. ClipboardItem includes UUID, text/image type, optional text/image filename, timestamp and pin state; retentionDays uses AppStorage/UserDefaults with default 3.

The app initializes store, monitor, menu controller and cleanup. Store publishes changes, persists CRUD and manages images. Monitor polls every 0.5 s, checks changeCount, distinguishes string/TIFF, deduplicates and supports pause/resume. Opening the popover pauses monitoring; closing resumes it. Views provide search/cards/pin/delete/retention. Cleanup runs at start and every ten minutes, removes expired unpinned items and associated images. Use thumbnails in lists rather than full images. The source specifies App Sandbox and local-only behavior. This translation does not independently benchmark or execute the app.
