//
//  AddEntrySheet.swift
//  Chroncurrency
//

import SwiftUI

/// Modal sheet that lets user type *or* dictate a custom entry.
struct AddEntrySheet: View {
    let store: LogStore
    @ObservedObject var helper: DictationHelper

    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @State private var kind: LogEntry.Kind = .symptom
    @State private var isDictating = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("e.g. Abdominal pain 6/10", text: $text)
                        .textInputAutocapitalization(.sentences)
                        .disableAutocorrection(false)

                    Picker("Type", selection: $kind) {
                        ForEach(LogEntry.Kind.allCases, id: \.self) { k in
                            Text(k.rawValue.capitalized).tag(k)
                        }
                    }
                }

                if isDictating {
                    Section("Live dictation") {
                        Text(helper.transcript.isEmpty ? "Listening…" : helper.transcript)
                            .italic()
                    }
                }
            }
            .navigationTitle("New entry")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        helper.stop()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let value = text.isEmpty ? helper.transcript : text
                        guard !value.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        store.quickAdd(kind, value: value)
                        helper.stop()
                        dismiss()
                    }
                    .bold()
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        toggleDictation()
                    } label: {
                        Image(systemName: isDictating ? "mic.fill" : "mic")
                            .font(.title2)
                    }
                }
            }
            .onDisappear { helper.stop() }
        }
    }

    private func toggleDictation() {
        if isDictating {
            helper.stop()
        } else {
            try? helper.start()
        }
        isDictating.toggle()
    }
}

