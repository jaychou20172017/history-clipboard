import AppKit
import Foundation

class ClipboardMonitor {
    private let pasteboard = NSPasteboard.general
    private let store: ClipboardStore
    private var timer: Timer?
    private var lastChangeCount: Int = -1
    private var isPaused = false
    private var skipNextChange = false

    init(store: ClipboardStore) {
        self.store = store
    }

    func start(pollingInterval: TimeInterval = 0.5) {
        stop()
        lastChangeCount = pasteboard.changeCount
        let t = Timer(timeInterval: pollingInterval, repeats: true) { [weak self] _ in
            self?.checkPasteboard()
        }
        t.tolerance = pollingInterval * 0.2
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func pause() {
        isPaused = true
        skipNextChange = true
    }

    func resume() {
        isPaused = false
        skipNextChange = false
        lastChangeCount = pasteboard.changeCount
    }

    func skipNext() {
        skipNextChange = true
    }

    // MARK: - Private

    /// Try multiple pasteboard text types. WPS and some apps encode CJK
    /// characters as UTF-16, which may not decode correctly as UTF-8.
    /// We check UTF-16 first, then fall back to standard UTF-8.
    private func readTextFromPasteboard() -> String? {
        // 1. UTF-16 plain text — primary format for WPS and some CJK apps
        let utf16Type = NSPasteboard.PasteboardType("public.utf16-plain-text")
        if let data = pasteboard.data(forType: utf16Type),
           let text = String(data: data, encoding: .utf16LittleEndian)
                   ?? String(data: data, encoding: .utf16BigEndian),
           !text.isEmpty {
            return text
        }

        // 2. Standard UTF-8 plain text — works for most apps
        if let text = pasteboard.string(forType: .string), !text.isEmpty {
            return text
        }

        return nil
    }

    private func checkPasteboard() {
        guard !isPaused else { return }

        let currentChangeCount = pasteboard.changeCount
        guard currentChangeCount != lastChangeCount else { return }
        lastChangeCount = currentChangeCount

        if skipNextChange {
            skipNextChange = false
            return
        }

        if let text = readTextFromPasteboard() {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            guard !store.itemExists(with: trimmed) else { return }

            let item = ClipboardItem(type: .text, textContent: trimmed)
            store.addItem(item)
            return
        }

        if let imageData = ImageHelper.imageDataFromPasteboard(pasteboard) {
            let itemId = UUID()
            let fileName = ImageHelper.imageFileName(for: itemId, data: imageData)
            guard !store.imageExists(withFileName: fileName) else { return }

            let imagesURL = store.imagesDirectoryURL()
            if ImageHelper.saveImage(imageData, fileName: fileName, imagesURL: imagesURL) {
                let item = ClipboardItem(
                    id: itemId,
                    type: .image,
                    imageFileName: fileName
                )
                store.addItem(item)
            }
        }
    }
}
