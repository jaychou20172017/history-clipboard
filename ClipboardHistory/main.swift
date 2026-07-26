import AppKit

// Entry point: manually set up the application without SwiftUI App lifecycle
// to ensure NSApplicationDelegate works correctly for the menu bar app.

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBarController: MenuBarController?
    private var cleanupService: CleanupService?
    private var store: ClipboardStore?
    private var monitor: ClipboardMonitor?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Default retention: 3 days
        if UserDefaults.standard.integer(forKey: "retentionDays") == 0 {
            UserDefaults.standard.set(3, forKey: "retentionDays")
        }

        let store = ClipboardStore()
        let monitor = ClipboardMonitor(store: store)
        monitor.start()

        let cleanup = CleanupService(store: store)
        cleanup.start()

        self.store = store
        self.monitor = monitor
        cleanupService = cleanup
        menuBarController = MenuBarController(store: store, monitor: monitor)
    }
}

// Auto-start via @main replacement
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory) // No Dock icon
app.run()
