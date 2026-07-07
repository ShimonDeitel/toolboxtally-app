import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [ToolEntry] = []
    @Published var showPaywall: Bool = false

    /// Free tier allows well above the seeded sample count so a fresh install never hits the paywall.
    static let freeLimit = 12

    private let fileName = "toolboxtally_entries.json"
    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
        if entries.isEmpty {
            seed()
        }
    }

    func seed() {
        entries = [
            ToolEntry(),
            ToolEntry(),
            ToolEntry()
        ]
        save()
    }

    var isAtFreeLimit: Bool {
        entries.count >= Store.freeLimit
    }

    func canAdd(isPro: Bool) -> Bool {
        isPro || entries.count < Store.freeLimit
    }

    @discardableResult
    func add(_ entry: ToolEntry, isPro: Bool) -> Bool {
        guard canAdd(isPro: isPro) else {
            showPaywall = true
            return false
        }
        entries.append(entry)
        save()
        return true
    }

    func update(_ entry: ToolEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: ToolEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([ToolEntry].self, from: data) {
            entries = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
