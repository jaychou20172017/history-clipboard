import AppKit
import Foundation

enum ImageHelper {
    static let thumbnailMaxSize: CGFloat = 200

    /// Save image data to the images directory, returns the file name used
    static func saveImage(_ data: Data, fileName: String, imagesURL: URL) -> Bool {
        let fileURL = imagesURL.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL, options: .atomicWrite)
            return true
        } catch {
            print("Failed to save image: \(error)")
            return false
        }
    }

    /// Load image from the images directory
    static func loadImage(fileName: String, imagesURL: URL) -> NSImage? {
        let fileURL = imagesURL.appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        return NSImage(contentsOf: fileURL)
    }

    /// Generate a thumbnail from image data
    static func thumbnail(from data: Data) -> NSImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return NSImage(data: data)
        }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: thumbnailMaxSize,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return NSImage(data: data)
        }
        return NSImage(cgImage: cgImage, size: .zero)
    }

    /// Generate file name for image based on UUID
    static func imageFileName(for itemId: UUID, data: Data) -> String {
        let ext = imageFileExtension(for: data)
        return "\(itemId.uuidString).\(ext)"
    }

    /// Detect image file extension from data
    static func imageFileExtension(for data: Data) -> String {
        var bytes = [UInt8](repeating: 0, count: 1)
        data.copyBytes(to: &bytes, count: 1)

        switch bytes[0] {
        case 0xFF: return "jpg"
        case 0x89: return "png"
        case 0x47: return "gif"
        case 0x49, 0x4D: return "tiff"
        case 0x52: return "webp"  // RIFF header
        default: return "png"
        }
    }

    /// Get NSImage from pasteboard as TIFF data
    static func imageDataFromPasteboard(_ pasteboard: NSPasteboard) -> Data? {
        if let tiffData = pasteboard.data(forType: .tiff) {
            return tiffData
        }
        if let pngData = pasteboard.data(forType: .png) {
            return pngData
        }
        return nil
    }
}
