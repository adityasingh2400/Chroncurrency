import SwiftUI

struct StoolDetailSheet: View {
    let store: LogStore
    @Environment(\.dismiss) private var dismiss

    // Buckets
    enum Consistency: String, CaseIterable { case fullyFormed, partiallyFormed, unformed }
    enum Blood: String, CaseIterable { case onPaper, inWater, mainlyBlood }

    @State private var consistency: Consistency = .fullyFormed
    @State private var urgency: Double = 5                 // slider 1…10
    @State private var blood: Blood = .onPaper

    var body: some View {
        NavigationStack {
            Form {
                Section("Consistency") {
                    Picker("", selection: $consistency) {
                        ForEach(Consistency.allCases, id: \.self) { c in
                            Text(label(for: c)).tag(c)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Urgency") {
                    Slider(value: $urgency, in: 1...10, step: 1) {
                        Text("Urgency")
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("10")
                    }
                }

                Section("Blood") {
                    Picker("", selection: $blood) {
                        ForEach(Blood.allCases, id: \.self) { b in
                            Text(label(for: b)).tag(b)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Stool details")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        store.quickAdd(.stool, value: summaryString)
                        dismiss()
                    }.bold()
                }
            }
        }
    }

    // MARK: – Helpers
    private var summaryString: String {
        """
        Consistency: \(label(for: consistency)), \
        Urgency: \(Int(urgency)), \
        Blood: \(label(for: blood))
        """
    }

    private func label(for c: Consistency) -> String {
        switch c {
        case .fullyFormed:      return "fully formed"
        case .partiallyFormed:  return "partially formed"
        case .unformed:         return "unformed"
        }
    }
    private func label(for b: Blood) -> String {
        switch b {
        case .onPaper:     return "blood on paper"
        case .inWater:     return "in water"
        case .mainlyBlood: return "mainly blood"
        }
    }
}

