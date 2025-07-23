import SwiftUI
import SwiftData

struct TimelineScreen: View {
    @Environment(\.modelContext) private var ctx
    @State private var store: LogStore!

    // UI state
    @State private var isAdding     = false
    @State private var showAll      = false
    @State private var wantsStool   = false
    @State private var dictHelper   = DictationHelper()
    @State private var showConfirm  = false     // delete-all alert
    @State private var wantsPain  = false   // NEW


    var body: some View {
        NavigationStack {
            VStack {
                if store != nil {
                    QuickAddCircle(store: store,
                                   isAdding: $isAdding,
                                   wantsStoolSheet: $wantsStool,
                                   wantsPainSheet: $wantsPain)

                    // preview last-5 or full list
                    List {
                        ForEach(displayedLogs) { entry in
                            TimelineRow(entry: entry)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        store.delete(entry)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                        //To show all or collapse all logged things.
                        if needsToggle {
                            Button(showAll ? "Collapse" : "Show all") {
                                withAnimation { showAll.toggle() }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showConfirm = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            //Delete Button
            .alert("Delete all logs?",
                   isPresented: $showConfirm) {
                Button("Delete", role: .destructive) { store.deleteAll() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This cannot be undone.")
            }
            // sheets
            .sheet(isPresented: $isAdding) {
                AddEntrySheet(store: store, helper: dictHelper)
                    .presentationDetents([.medium])
            }

            //Fullscreen view for stool
            .fullScreenCover(isPresented: $wantsStool) {
                StoolDetailSheet(store: store)
            }
            //Full screen view for pain
            .fullScreenCover(isPresented: $wantsPain) {
                PainDetailSheet(store: store)
            }

            .onAppear { store = LogStore(context: ctx) }
            .animation(.default, value: store?.todayLogs)
        }
    }

    // MARK: – Helpers
    private var needsToggle: Bool { (store?.todayLogs.count ?? 0) > 5 }
    private var displayedLogs: [LogEntry] {
        guard let logs = store?.todayLogs else { return [] }
        return needsToggle && !showAll ? Array(logs.prefix(5)) : logs
    }
    // MARK: – Row view for each log entry
    private struct TimelineRow: View {
        let entry: LogEntry

        /// Re-use one formatter for perf
        private static let timeFmt: DateFormatter = {
            let f = DateFormatter()
            f.timeStyle = .short
            return f
        }()

        var body: some View {
            HStack {
                Image(systemName: icon(for: entry.kind))
                    .foregroundStyle(.tint)
                VStack(alignment: .leading) {
                    Text(entry.value).bold()
                    Text(Self.timeFmt.string(from: entry.timestamp))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }

        private func icon(for kind: LogEntry.Kind) -> String {
            switch kind {
            case .symptom:    return "bolt.heart"
            case .medication: return "pills.fill"
            case .meal:       return "fork.knife"
            case .stool:      return "drop.triangle"
            case .note:       return "note.text"
            }
        }
    }

}

