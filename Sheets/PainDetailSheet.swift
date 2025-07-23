//
//  PainDetailSheet.swift   (simplified: no silhouette)
//  Chroncurrency
//

import SwiftUI

struct PainDetailSheet: View {
    let store: LogStore
    @Environment(\.dismiss) private var dismiss

    // Wizard steps
    private enum Step { case location, intensity }

    // Regions to pick from
    private enum Region: String, CaseIterable, Identifiable {
        case head, abdomen, legs
        var id: String { rawValue }
        var title: String {
            switch self {
            case .head:    "Head"
            case .abdomen: "Stomach"
            case .legs:    "Legs"
            }
        }
    }

    // State
    @State private var step: Step = .location
    @State private var region: Region?
    @State private var intensity: Double = 3   // 1‒5 slider

    // MARK: – UI
    var body: some View {
        NavigationStack {
            ZStack {
                switch step {
                case .location: locationView
                case .intensity: intensityView
                }
            }
            .animation(.easeInOut, value: step)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if step == .location {
                        Button("Cancel") { dismiss() }
                    } else {
                        Button {
                            withAnimation { step = .location }
                        } label: {
                            Label("Back", systemImage: "chevron.left")
                        }
                    }
                }
            }
            .navigationTitle("Pain details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: – Step 1  Location buttons
    private var locationView: some View {
        VStack(spacing: 28) {
            Text("Where is the pain?")
                .font(.title2).bold()

            ForEach(Region.allCases) { r in
                Button {
                    region = r
                    withAnimation { step = .intensity }
                } label: {
                    Text(r.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.gray.opacity(0.15))
                        )
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }

    // MARK: – Step 2  Intensity
    private var intensityView: some View {
        VStack(spacing: 32) {
            Text("How bad is it?")
                .font(.title2).bold()

            Text(intensityDescription)
                .font(.headline)

            Slider(value: $intensity, in: 1...5, step: 1)
                .padding(.horizontal, 40)

            Spacer()

            Button {
                let summary = "Pain – \(region?.title ?? "Unknown") – \(Int(intensity))/5"
                store.quickAdd(.symptom, value: summary)
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
            .padding(.horizontal, 60)
            .padding(.bottom, 40)
        }
    }

    private var intensityDescription: String {
        switch Int(intensity) {
        case 1: "Very mild"
        case 2: "Mild"
        case 3: "Moderate"
        case 4: "Severe"
        default: "Excruciating"
        }
    }
}

