//
//  StoolDetailSheet.swift   (full-screen wizard, back button, 1-5 urgency)
//  Chroncurrency
//

import SwiftUI

struct StoolDetailSheet: View {
    let store: LogStore
    @Environment(\.dismiss) private var dismiss

    // MARK: enums
    enum Consistency: String, CaseIterable { case fullyFormed, partiallyFormed, unformed }
    enum Blood: String, CaseIterable      { case onPaper, inWater, mainlyBlood }
    private enum Step { case consistency, urgency, blood }

    // wizard state
    @State private var step: Step = .consistency
    @State private var consistency: Consistency?
    @State private var urgency: Double = 3                   // slider 1‒5
    @State private var blood: Blood?

    var body: some View {
        NavigationStack {
            ZStack {                                      // slide-in container
                switch step {
                case .consistency: consistencyView
                case .urgency:      urgencyView
                case .blood:        bloodView
                }
            }
            .animation(.easeInOut, value: step)
            .navigationBarBackButtonHidden(true)          // custom back logic
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if step == .consistency {
                        Button("Cancel") { dismiss() }
                    } else {                              // show Back arrow
                        Button {
                            withAnimation { step = previous(step) }
                        } label: {
                            Label("Back", systemImage: "chevron.left")
                        }
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Stool details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: – step views
    private var consistencyView: some View {
        VStack(spacing: 32) {
            Text("Consistency")
                .font(.title2).bold()
            ForEach(Consistency.allCases, id: \.self) { c in
                bigButton(label(for: c)) {
                    consistency = c
                    withAnimation { step = .urgency }
                }
            }
        }
        .padding(.horizontal, 32)
    }

    private var urgencyView: some View {
        VStack(spacing: 36) {
            Text("Urgency")
                .font(.title2).bold()
            Text(urgencyDescription)
                .font(.headline)
            Slider(value: $urgency, in: 1...5, step: 1)
                .padding(.horizontal, 32)
            Button("Next") {
                withAnimation { step = .blood }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var bloodView: some View {
        VStack(spacing: 32) {
            Text("Blood")
                .font(.title2).bold()
            ForEach(Blood.allCases, id: \.self) { b in
                bigButton(label(for: b), isSelected: blood == b) {
                    blood = b
                }
            }
            Spacer(minLength: 40)
            // SAVE – only enabled after a selection
            if blood != nil {
                Button {
                    store.quickAdd(.stool, value: summaryString)
                    dismiss()
                } label: {
                    Text("SAVE")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Capsule().fill(Color.accentColor))
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                }
                .padding(.horizontal, 50)
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 32)
    }

    // MARK: – helpers
    private func bigButton(_ title: String,
                           isSelected: Bool = false,
                           action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title.capitalized)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isSelected ? Color.accentColor.opacity(0.3)
                                         : Color.gray.opacity(0.15))
                )
        }
    }

    private var urgencyDescription: String {
        switch Int(urgency) {
        case 1: "No rush"
        case 2: "Mild urge"
        case 3: "Moderate"
        case 4: "High urge"
        default: "Emergency!"
        }
    }

    private func label(for c: Consistency) -> String {
        switch c {
        case .fullyFormed: "fully formed"
        case .partiallyFormed: "partially formed"
        case .unformed: "unformed"
        }
    }
    private func label(for b: Blood) -> String {
        switch b {
        case .onPaper: "blood on paper"
        case .inWater: "in water"
        case .mainlyBlood: "mainly blood"
        }
    }
    private var summaryString: String {
        "Consistency: \(label(for: consistency ?? .fullyFormed)), " +
        "Urgency: \(Int(urgency)), " +
        "Blood: \(label(for: blood ?? .onPaper))"
    }
    private func previous(_ s: Step) -> Step {
        switch s {
        case .urgency: .consistency
        case .blood:   .urgency
        default:       .consistency
        }
    }
}

