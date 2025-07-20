/*import SwiftUI

struct QuickAddBar: View {
    let store: LogStore
    @Binding var isAdding: Bool
    @Binding var wantsStoolSheet: Bool        // NEW binding

    var body: some View {
        HStack(spacing: 12) {

            // “+”  → custom sheet
            Button { isAdding = true } label: {
                Image(systemName: "plus.circle")
                    .font(.title2)
            }

            //Dealign with user interactions with logging
            ForEach(LogEntry.Kind.allCases, id: \.self) { kind in
                Button {
                    if kind == .stool {
                        // stool now requires details → open the sheet
                        wantsStoolSheet = true
                    } else {
                        // all other kinds keep the instant-add behavior
                        store.quickAdd(kind, value: defaultLabel(for: kind))
                    }
                } label: {
                    Image(systemName: icon(for: kind))
                        .font(.title2)
                        .padding(10)
                        .background(
                            Circle().fill(Color.gray.opacity(0.15))
                        )
                }
            }


            Spacer()
        }
        .padding(.horizontal)
    }
}

// MARK: – Helpers
private func defaultLabel(for kind: LogEntry.Kind) -> String {
    switch kind {
    case .symptom:   return "Pain"
    case .medication:return "Mesalamine"
    case .meal:      return "Meal"
    case .stool:     return "Stool"
    case .note:      return "Note"
    }
}

private func icon(for kind: LogEntry.Kind) -> String {
    switch kind {
    case .symptom:   return "bolt.heart"
    case .medication:return "pills.fill"
    case .meal:      return "fork.knife"
    case .stool:     return "drop.triangle"
    case .note:      return "note.text"
    }
}
*/
