import SwiftUI
import SwiftData

@main
struct ChroncurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            TimelineScreen()
                // default container is fine for now; no custom PRAGMA needed
                .modelContainer(for: LogEntry.self)
        }
    }
}

