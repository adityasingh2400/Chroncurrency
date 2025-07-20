import Foundation
import SwiftData
import Observation

@Observable
final class LogStore {
    private let context: ModelContext
    var todayLogs: [LogEntry] = []

    // MARK: – Init
    init(context: ModelContext) {
        self.context = context
        refresh()
    }

    // MARK: – Public actions
    @MainActor
    func quickAdd(_ kind: LogEntry.Kind, value: String) {
        context.insert(LogEntry(kind: kind, value: value))
        try? context.save()
        refresh()
    }

    @MainActor
    func delete(_ entry: LogEntry) {
        context.delete(entry)
        try? context.save()
        refresh()
    }

    /// Wipes all entries (with confirmation handled at the UI layer)
    @MainActor
    func deleteAll() {
        for entry in todayLogs { context.delete(entry) }
        try? context.save()
        refresh()
    }

    // MARK: – Helper
    func refresh() {
        let sort  = SortDescriptor(\LogEntry.timestamp, order: .reverse)
        let fetch = FetchDescriptor<LogEntry>(sortBy: [sort])
        todayLogs = (try? context.fetch(fetch)) ?? []
    }
}

