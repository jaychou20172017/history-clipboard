import SwiftUI

struct ContentListView: View {
    @ObservedObject var store: ClipboardStore
    let monitor: ClipboardMonitor
    let closePopover: () -> Void

    @State private var searchText = ""
    @State private var isSelectionMode = false
    @State private var selectedIds = Set<UUID>()

    var body: some View {
        let displayedItems = store.sortedItems(filteredBy: searchText)

        VStack(spacing: 0) {
            // Search bar
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search history...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(nsColor: .quaternarySystemFill))

            Divider()

            // Content
            if displayedItems.isEmpty {
                emptyStateView(hasSearch: !searchText.isEmpty)
            } else {
                ScrollView {
                    LazyVStack(spacing: 6) {
                        ForEach(displayedItems) { item in
                            ClipboardCardView(
                                item: item,
                                isSelectionMode: isSelectionMode,
                                isSelected: selectedIds.contains(item.id),
                                onCopy: { copyItem(item) },
                                onToggleSelect: { toggleSelection(item.id) },
                                onPin: { store.togglePin(id: item.id) },
                                onDelete: { store.removeItem(id: item.id) }
                            )
                        }
                    }
                    .padding(8)
                }
            }

            // Bottom bar
            Divider()
            bottomBar(displayedItems: displayedItems)

            SettingsView()
        }
        .frame(width: 360)
        .onReceive(NotificationCenter.default.publisher(for: .popoverWillShow)) { _ in
            searchText = ""
            exitSelectionMode()
        }
    }

    // MARK: - Bottom Bar

    private func bottomBar(displayedItems: [ClipboardItem]) -> some View {
        HStack {
            if isSelectionMode {
                Button(action: toggleSelectAll) {
                    Text(allDisplayedSelected(displayedItems) ? "Deselect All" : "Select All")
                        .font(.caption)
                }
                .buttonStyle(.plain)

                Spacer()

                Button(action: deleteSelected) {
                    Label("Delete (\(selectedIds.count))", systemImage: "trash")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .foregroundColor(.red)
                .disabled(selectedIds.isEmpty)

                Button("Done") {
                    exitSelectionMode()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .font(.caption)
            } else {
                if !searchText.isEmpty {
                    Text("Found \(displayedItems.count) of \(store.items.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("\(store.items.count) items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()

                Button("Select") {
                    isSelectionMode = true
                    selectedIds = []
                }
                .buttonStyle(.plain)
                .font(.caption)
                .foregroundColor(.accentColor)

                Text("· Click card to copy")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
    }

    // MARK: - Empty State

    private func emptyStateView(hasSearch: Bool) -> some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: hasSearch ? "magnifyingglass" : "clipboard")
                .font(.system(size: 36))
                .foregroundColor(.secondary)
            Text(hasSearch ? "No Results" : "No Clipboard History")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
            Text(hasSearch ? "Try a different search term" : "Copied text and images will appear here")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Selection Actions

    private func toggleSelection(_ id: UUID) {
        if selectedIds.contains(id) {
            selectedIds.remove(id)
        } else {
            selectedIds.insert(id)
        }
    }

    private func toggleSelectAll() {
        let displayed = store.sortedItems(filteredBy: searchText)
        if allDisplayedSelected(displayed) {
            selectedIds = []
        } else {
            selectedIds = Set(displayed.map(\.id))
        }
    }

    private func allDisplayedSelected(_ items: [ClipboardItem]) -> Bool {
        !items.isEmpty && items.allSatisfy { selectedIds.contains($0.id) }
    }

    private func deleteSelected() {
        store.removeItems(ids: selectedIds)
        exitSelectionMode()
    }

    private func exitSelectionMode() {
        isSelectionMode = false
        selectedIds = []
    }

    // MARK: - Copy Action

    private func copyItem(_ item: ClipboardItem) {
        monitor.skipNext()

        switch item.type {
        case .text:
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(item.textContent ?? "", forType: .string)
        case .image:
            if let fileName = item.imageFileName {
                let imageURL = store.imagesDirectoryURL().appendingPathComponent(fileName)
                if let image = NSImage(contentsOf: imageURL) {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.writeObjects([image])
                }
            }
        }

        closePopover()
    }
}
