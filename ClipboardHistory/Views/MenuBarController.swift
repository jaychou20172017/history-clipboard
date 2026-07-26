import AppKit
import SwiftUI

extension Notification.Name {
    static let popoverWillShow = Notification.Name("popoverWillShow")
}

final class MenuBarController: NSObject, NSPopoverDelegate {
    private let store: ClipboardStore
    private let monitor: ClipboardMonitor
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var hostingController: NSHostingController<ContentListView>!

    init(store: ClipboardStore, monitor: ClipboardMonitor) {
        self.store = store
        self.monitor = monitor
        super.init()
        setupStatusBar()
        setupPopover()
    }

    // MARK: - Status Bar

    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            let image = NSImage(
                systemSymbolName: "list.clipboard",
                accessibilityDescription: "Clipboard History"
            )
            image?.isTemplate = true
            button.image = image
            button.target = self
            button.action = #selector(togglePopover)
        }
    }

    // MARK: - Popover

    private func setupPopover() {
        popover = NSPopover()
        popover.delegate = self
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 360, height: 480)

        let contentView = ContentListView(
            store: store,
            monitor: monitor,
            closePopover: { [weak self] in
                self?.popover?.performClose(nil)
            }
        )
        hostingController = NSHostingController(rootView: contentView)
        popover.contentViewController = hostingController
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            NotificationCenter.default.post(name: .popoverWillShow, object: nil)
            monitor.pause()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    // MARK: - NSPopoverDelegate

    func popoverDidClose(_ notification: Notification) {
        monitor.resume()
    }
}
