import SwiftUI

struct ClipboardCardView: View {
    let item: ClipboardItem
    let isSelectionMode: Bool
    let isSelected: Bool
    let onCopy: () -> Void
    let onToggleSelect: () -> Void
    let onPin: () -> Void
    let onDelete: () -> Void

    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 8) {
            // Selection checkbox
            if isSelectionMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .font(.system(size: 16))
                    .onTapGesture { onToggleSelect() }
            }

            // Type icon (hidden in selection mode)
            if !isSelectionMode {
                Image(systemName: item.type == .image ? "photo" : "doc.text")
                    .foregroundColor(.secondary)
                    .frame(width: 16)
            }

            // Content preview
            VStack(alignment: .leading, spacing: 2) {
                if item.type == .text {
                    Text(item.textContent ?? "")
                        .lineLimit(2)
                        .font(.system(size: 13))
                } else {
                    Text("[Image]")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Timestamp & actions (hidden in selection mode)
            if !isSelectionMode {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(item.timestamp, style: .time)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)

                    if isHovering {
                        HStack(spacing: 8) {
                            Button(action: onPin) {
                                Image(systemName: item.isPinned ? "pin.fill" : "pin")
                                    .font(.system(size: 11))
                            }
                            .buttonStyle(.plain)
                            .help(item.isPinned ? "Unpin" : "Pin to top")

                            Button(action: onDelete) {
                                Image(systemName: "trash")
                                    .font(.system(size: 11))
                            }
                            .buttonStyle(.plain)
                            .help("Delete")
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
        )
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isSelectionMode {
                onToggleSelect()
            } else {
                onCopy()
            }
        }
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.accentColor.opacity(0.15)
        }
        if isHovering {
            return Color(nsColor: .quaternarySystemFill)
        }
        return Color(nsColor: .quinarySystemFill)
    }
}
