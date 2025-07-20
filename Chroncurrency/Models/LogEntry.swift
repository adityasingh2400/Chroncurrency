import Foundation
import SwiftData

@Model
final class LogEntry: Identifiable, Hashable {
    enum Kind: String, Codable, CaseIterable {
        case symptom, medication, meal, stool, note
    }

    @Attribute(.unique) var id: UUID   = UUID()   // ← use UUID(), not .init()
    var timestamp: Date               = Date()   // ← use Date(), not .now
    var kind: Kind
    var value: String
    var extra: Data?                  // room for JSON later

    init(kind: Kind, value: String, timestamp: Date = Date()) {
        self.kind      = kind
        self.value     = value
        self.timestamp = timestamp
    }
}

