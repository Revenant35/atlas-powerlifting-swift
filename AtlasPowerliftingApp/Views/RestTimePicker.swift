//
//  RestTimePicker.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI

struct RestTimePicker: View {
    @Binding var totalSeconds: Int

    private let maxMinutes = 10

    private var minutes: Int {
        totalSeconds / 60
    }

    private var seconds: Int {
        totalSeconds % 60
    }

    var body: some View {
        HStack(spacing: 0) {
            Picker("Minutes", selection: Binding(
                get: { minutes },
                set: { totalSeconds = $0 * 60 + seconds }
            )) {
                ForEach(0...maxMinutes, id: \.self) {
                    Text("\($0) min")
                }
            }

            Picker("Seconds", selection: Binding(
                get: { seconds },
                set: { totalSeconds = minutes * 60 + $0 }
            )) {
                ForEach([0, 15, 30, 45], id: \.self) {
                    Text(String(format: "%02d sec", $0))
                }
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 150)
        .clipped()
    }
}

#Preview {
    @Previewable @State var totalSeconds = 0
    
    return RestTimePicker(totalSeconds: $totalSeconds)
}

