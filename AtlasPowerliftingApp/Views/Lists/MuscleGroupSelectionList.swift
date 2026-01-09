//
//  MuscleGroupSelectionList.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI

struct MuscleGroupSelectionList: View {
    @Binding var selectedMuscleGroups: [MuscleGroup]

    var body: some View {
        List(MuscleGroup.allCases, id: \.self) { muscleGroup in
            Button {
                toggleSelection(for: muscleGroup)
            } label: {
                HStack {
                    Text(muscleGroup.rawValue)
                        .foregroundStyle(.primary)

                    Spacer()

                    if selectedMuscleGroups.contains(muscleGroup) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Select Muscle Groups")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleSelection(for muscleGroup: MuscleGroup) {
        if let index = selectedMuscleGroups.firstIndex(of: muscleGroup) {
            selectedMuscleGroups.remove(at: index)
        } else {
            selectedMuscleGroups.append(muscleGroup)
        }
    }
}

#Preview {
    @Previewable @State var selectedMuscleGroups: [MuscleGroup] = [.chest, .triceps]

    return NavigationStack {
        MuscleGroupSelectionList(selectedMuscleGroups: $selectedMuscleGroups)
    }
}
