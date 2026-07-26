import Foundation
import Combine

class ClipboardStore: ObservableObject {
    @Published var items: [ClipboardItem] = []

    private let storageURL: URL
    private let imagesURL: URL
    private let queue = DispatchQueue(label: "com.clipboardhistory.store", qos: .userInitiated)
    private let maxItems = 500

    init() {
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask
        ).first!

        let baseURL = appSupport.appendingPathComponent("ClipboardHistory")
        storageURL = baseURL.appendingPathComponent("items.json")
        imagesURL = baseURL.appendingPathComponent("images")

        createDirectoriesIfNeeded()
        loadItems()
    }

    // MARK: - CRUD

    func addItem(_ item: ClipboardItem) {
        queue.async { [weak self] in
            guard let self = self else { return }
            var current = self.items

            if current.count >= self.maxItems {
                current.removeLast(current.count - self.maxItems + 1)
            }

            current.insert(item, at: 0)
            self.updateItems(current)
        }
    }

    func removeItem(id: UUID) {
        queue.async { [weak self] in
            guard let self = self else { return }
            var current = self.items
            if let index = current.firstIndex(where: { $0.id == id }) {
                let item = current[index]
                if item.type == .image, let fileName = item.imageFileName {
                    self.deleteImageFile(fileName)
                }
                current.remove(at: index)
                self.updateItems(current)
            }
        }
    }

    func removeItems(ids: Set<UUID>) {
        guard !ids.isEmpty else { return }
        queue.async { [weak self] in
            guard let self = self else { return }
            var current = self.items
            let toRemove = current.filter { ids.contains($0.id) }
            for item in toRemove {
                if item.type == .image, let fileName = item.imageFileName {
                    self.deleteImageFile(fileName)
                }
            }
            current.removeAll { ids.contains($0.id) }
            self.updateItems(current)
        }
    }

    func togglePin(id: UUID) {
        queue.async { [weak self] in
            guard let self = self else { return }
            var current = self.items
            if let index = current.firstIndex(where: { $0.id == id }) {
                current[index].isPinned.toggle()
                self.updateItems(current)
            }
        }
    }

    func itemExists(with text: String) -> Bool {
        items.first(where: { $0.textContent == text }) != nil
    }

    func imageExists(withFileName name: String) -> Bool {
        items.first(where: { $0.imageFileName == name }) != nil
    }

    /// Returns items sorted: pinned first, then by timestamp descending within each group
    func sortedItems(filteredBy searchText: String = "") -> [ClipboardItem] {
        let filtered: [ClipboardItem]
        if searchText.isEmpty {
            filtered = items
        } else {
            let query = searchText.lowercased()
            filtered = items.filter { item in
                item.textContent?.lowercased().contains(query) ?? false
            }
        }

        return filtered.sorted { a, b in
            if a.isPinned != b.isPinned {
                return a.isPinned
            }
            return a.timestamp > b.timestamp
        }
    }

    func deleteExpiredItems(olderThanDays days: Int) {
        let cutoff = Calendar.current.date(
            byAdding: .day, value: -days, to: Date()
        ) ?? Date()

        queue.async { [weak self] in
            guard let self = self else { return }
            let expired = self.items.filter { !$0.isPinned && $0.timestamp < cutoff }
            let remaining = self.items.filter { $0.isPinned || $0.timestamp >= cutoff }

            for item in expired {
                if item.type == .image, let fileName = item.imageFileName {
                    self.deleteImageFile(fileName)
                }
            }

            self.updateItems(remaining)
        }
    }

    // MARK: - Persistence

    private func loadItems() {
        queue.async { [weak self] in
            guard let self = self else { return }
            guard FileManager.default.fileExists(atPath: self.storageURL.path) else {
                DispatchQueue.main.async { self.items = [] }
                return
            }
            do {
                let data = try Data(contentsOf: self.storageURL)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decoded = try decoder.decode([ClipboardItem].self, from: data)
                DispatchQueue.main.async { self.items = decoded }
            } catch {
                print("Failed to load items: \(error)")
                DispatchQueue.main.async { self.items = [] }
            }
        }
    }

    private func saveItems(_ items: [ClipboardItem]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(items)
            try data.write(to: storageURL, options: .atomicWrite)
        } catch {
            print("Failed to save items: \(error)")
        }
    }

    private func updateItems(_ newItems: [ClipboardItem]) {
        saveItems(newItems)
        DispatchQueue.main.async { [weak self] in
            self?.items = newItems
        }
    }

    // MARK: - Helpers

    private func createDirectoriesIfNeeded() {
        let baseURL = storageURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: baseURL.path) {
            try? FileManager.default.createDirectory(
                at: baseURL, withIntermediateDirectories: true
            )
        }
        if !FileManager.default.fileExists(atPath: imagesURL.path) {
            try? FileManager.default.createDirectory(
                at: imagesURL, withIntermediateDirectories: true
            )
        }
    }

    func imagesDirectoryURL() -> URL {
        imagesURL
    }

    private func deleteImageFile(_ fileName: String) {
        let fileURL = imagesURL.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }
}
