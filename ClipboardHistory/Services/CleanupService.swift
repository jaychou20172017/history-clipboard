import Foundation

class CleanupService {
    private let store: ClipboardStore
    private var timer: Timer?

    init(store: ClipboardStore) {
        self.store = store
    }

    func start() {
        // Run cleanup immediately on start
        performCleanup()

        // Then every 10 minutes
        let t = Timer(timeInterval: 600, repeats: true) { [weak self] _ in
            self?.performCleanup()
        }
        t.tolerance = 60
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func performCleanup() {
        let days = UserDefaults.standard.integer(forKey: "retentionDays")
        guard days > 0 else { return }
        store.deleteExpiredItems(olderThanDays: days)
    }
}
