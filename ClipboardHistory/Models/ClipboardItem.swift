import Foundation

enum ItemType: String, Codable {
    case text
    case image
}

struct ClipboardItem: Identifiable, Codable, Equatable {
    let id: UUID
    let type: ItemType
    var textContent: String?
    var imageFileName: String?
    let timestamp: Date
    var isPinned: Bool

    init(
        id: UUID = UUID(),
        type: ItemType,
        textContent: String? = nil,
        imageFileName: String? = nil,
        timestamp: Date = Date(),
        isPinned: Bool = false
    ) {
        self.id = id
        self.type = type
        self.textContent = textContent
        self.imageFileName = imageFileName
        self.timestamp = timestamp
        self.isPinned = isPinned
    }
}
