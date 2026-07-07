import Foundation

struct ToolEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var storageSpot: String
    var borrowedBy: String
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), name: String = "", storageSpot: String = "", borrowedBy: String = "", notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.storageSpot = storageSpot
        self.borrowedBy = borrowedBy
        self.notes = notes
        self.createdAt = createdAt
    }
}
