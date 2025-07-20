//
//  QuickAddCircle.swift
//  Chroncurrency
//
//  A radial arrangement of the five quick-log presets.
//  Labels come first, then the (larger) icon button.
//

import SwiftUI

struct QuickAddCircle: View {
    let store: LogStore
    @Binding var isAdding: Bool          // “+” sheet trigger
    @Binding var wantsStoolSheet: Bool   // stool details trigger

    private let kinds = LogEntry.Kind.allCases
    private let radius: CGFloat = 120    // circle size

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ▸ central “+” button
                Button {
                    isAdding = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: 56, height: 56)
                        .background(Circle().fill(Color.accentColor))
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                }
                .position(x: geo.size.width / 2,
                          y: geo.size.height / 2)

                // ▸ place each preset at an angle around the circle
                ForEach(Array(kinds.enumerated()), id: \.1) { index, kind in
                    let angle = Angle(degrees: Double(index) /
                                      Double(kinds.count) * 360 - 90)
                    let x = cos(angle.radians) * radius
                    let y = sin(angle.radians) * radius

                    VStack(spacing: 4) {
                        // label BEFORE icon, per requirement
                        Text(label(for: kind))
                            .font(.caption2)
                            .multilineTextAlignment(.center)

                        Button {
                            if kind == .stool {
                                wantsStoolSheet = true
                            } else {
                                store.quickAdd(kind,
                                               value: defaultValue(for: kind))
                            }
                        } label: {
                            Image(systemName: icon(for: kind))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 38, height: 38)
                                .padding(22)
                                .background(
                                    Capsule()
                                        .fill(Color.gray.opacity(0.15))
                                )
                        }
                    }
                    // place the whole VStack on the circle
                    .position(x: geo.size.width / 2 + CGFloat(x),
                              y: geo.size.height / 2 + CGFloat(y))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        // give the GeometryReader a fixed height so it doesn’t collapse
        .frame(height: radius * 2 + 100)
        .padding(.vertical, 8)
    }

    // MARK: – helper labels & icons
    private func defaultValue(for kind: LogEntry.Kind) -> String {
        switch kind {
        case .symptom:   "Pain"
        case .medication:"Mesalamine"
        case .meal:      "Meal"
        case .stool:     "Stool"
        case .note:      "Note"
        }
    }
    private func label(for kind: LogEntry.Kind) -> String {
        switch kind {
        case .symptom:   "Pain"
        case .medication:"Medication"
        case .meal:      "Meal"
        case .stool:     "Stool"
        case .note:      "Note"
        }
    }
    private func icon(for kind: LogEntry.Kind) -> String {
        switch kind {
        case .symptom:    "bolt.heart"
        case .medication: "pills.fill"
        case .meal:       "fork.knife"
        case .stool:      "drop.triangle"
        case .note:       "note.text"
        }
    }
}
