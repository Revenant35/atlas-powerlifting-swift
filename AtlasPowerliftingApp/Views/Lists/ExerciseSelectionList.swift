//
//  ExerciseSelectionList.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct ExerciseSelectionList: View {
    @Query(
        sort: \Exercise.createdAt,
        order: .reverse
    )
    private var exercises: [Exercise]

    @Binding var selectedExercise: Exercise?

    @Environment(\.dismiss) private var dismiss

    @State private var searchQuery = ""
    @State private var selectedMuscleGroupFilters: Set<MuscleGroup> = []

    private var availableMuscleGroups: [MuscleGroup] {
        let allMuscleGroups = exercises.flatMap { $0.muscleGroups }
        return Array(Set(allMuscleGroups)).sorted { $0.rawValue < $1.rawValue }
    }

    private var filteredExercises: [Exercise] {
        exercises.filter { exercise in
            // Search filter
            let matchesSearch = searchQuery.isEmpty ||
                exercise.name.localizedCaseInsensitiveContains(searchQuery)

            // Muscle group filter
            let matchesMuscleGroups = selectedMuscleGroupFilters.isEmpty ||
                !Set(exercise.muscleGroups).isDisjoint(with: selectedMuscleGroupFilters)

            return matchesSearch && matchesMuscleGroups
        }
    }

    var body: some View {
        Group {
            if filteredExercises.isEmpty {
                if exercises.isEmpty {
                    ContentUnavailableView(
                        "No Exercises",
                        systemImage: "dumbbell",
                        description: Text("Create exercises in the Exercise Library first")
                    )
                } else {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text("No exercises match your search and filters")
                    )
                }
            } else {
                List(filteredExercises) { exercise in
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
        .searchable(text: $searchQuery, prompt: "Search exercises")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(availableMuscleGroups, id: \.self) { muscleGroup in
                        Toggle(isOn: Binding(
                            get: { selectedMuscleGroupFilters.contains(muscleGroup) },
                            set: { isSelected in
                                if isSelected {
                                    selectedMuscleGroupFilters.insert(muscleGroup)
                                } else {
                                    selectedMuscleGroupFilters.remove(muscleGroup)
                                }
                            }
                        )) {
                            Text(muscleGroup.rawValue)
                        }
                    }

                    if !selectedMuscleGroupFilters.isEmpty {
                        Divider()
                        Button("Clear Filters") {
                            selectedMuscleGroupFilters.removeAll()
                        }
                    }
                } label: {
                    Label("Filter", systemImage: selectedMuscleGroupFilters.isEmpty ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
                .disabled(availableMuscleGroups.isEmpty)
            }
        }
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
