//
//  WeekPicker.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/11/26.
//

import SwiftUI

struct WeekPicker: View {
    @Binding var selectedWeek: Int

    var canIncreaseWeek: Bool {
        selectedWeek < WorkoutProgram.maxWeeks
    }
    
    var canDecreaseWeek: Bool {
        selectedWeek > WorkoutProgram.minWeeks
    }

    var body: some View {
        HStack {
            Button {
                guard canDecreaseWeek else { return }
                
                selectedWeek -= 1
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(!canDecreaseWeek)
            
            Spacer()

            Text("Week \(selectedWeek)")
                .font(.headline)
            
            Spacer()

            Button {
                guard canIncreaseWeek else { return }
                selectedWeek += 1
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(!canIncreaseWeek)
        }
    }
}

#Preview {
    @Previewable @State var selectedWeek = WorkoutProgram.minWeeks

    return WeekPicker(selectedWeek: $selectedWeek)
}
