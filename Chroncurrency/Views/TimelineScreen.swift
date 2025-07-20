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

    var body: some View {
        NavigationStack {
            VStack {
                if store != nil {
                    QuickAddBar(store: store,
                                isAdding: $isAdding,
                                wantsStoolSheet: $wantsStool)

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
            .navigationTitle("Timeline")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showConfirm = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
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
            .sheet(isPresented: $wantsStool) {
                StoolDetailSheet(store: store)
                    .presentationDetents([.medium])
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
}

