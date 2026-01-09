//
//  ExerciseSelectionList.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct ExerciseSelectionList: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]

    @Binding var selectedExercise: Exercise?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if exercises.isEmpty {
                ContentUnavailableView(
                    "No Exercises",
                    systemImage: "dumbbell",
                    description: Text("Create exercises in the Exercise Library first")
                )
            } else {
                List(exercises) { exercise in
                    Button {
                        selectedExercise = exercise
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(exercise.name)
                                    .font(.body)
                                    .foregroundStyle(.primary)

                                if !exercise.muscleGroups.isEmpty {
                                    Text(exercise.muscleGroups.map { $0.rawValue }.joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }

                            Spacer()

                            if selectedExercise?.id == exercise.id {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(.blue)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Select Exercise")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var selectedExercise: Exercise? = nil

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Exercise.self,
        configurations: config
    )

    let exercise1 = Exercise(
        name: "Squat",
        exerciseDescription: "Barbell back squat",
        muscleGroups: [.quads, .glutes]
    )
    let exercise2 = Exercise(
        name: "Bench Press",
        exerciseDescription: "Barbell bench press",
        muscleGroups: [.chest, .triceps]
    )
    let exercise3 = Exercise(
        name: "Deadlift",
        exerciseDescription: "Conventional deadlift",
        muscleGroups: [.back, .hamstrings]
    )

    container.mainContext.insert(exercise1)
    container.mainContext.insert(exercise2)
    container.mainContext.insert(exercise3)

    return NavigationStack {
        ExerciseSelectionList(selectedExercise: $selectedExercise)
            .modelContainer(container)
    }
}
