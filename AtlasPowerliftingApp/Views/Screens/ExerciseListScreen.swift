//
//  ExerciseListScreen.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct ExerciseListScreen: View {
    @Environment(\.modelContext) private var modelContext

    @Query(
        sort: \Exercise.createdAt,
        order: .reverse
    )
    private var exercises: [Exercise]

    @State private var searchQuery = ""
    @State private var showingAddExercise = false

    private var filteredExercises: [Exercise] {
        if searchQuery.isEmpty {
            return exercises
        }
        return exercises.filter { exercise in
            exercise.name.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if filteredExercises.isEmpty {
                    NoExercises(searchQuery: searchQuery)
                } else {
                    List {
                        ForEach(filteredExercises) { exercise in
                            NavigationLink {
                                ExerciseDetailScreen(exercise: exercise)
                            } label: {
                                ExerciseListItem(exercise: exercise)
                            }
                        }
                        .onDelete(perform: deleteExercises)
                    }
                }
            }
            .navigationTitle("Exercises")
            .searchable(text: $searchQuery, prompt: "Search exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExercise = true }) {
                        Label("Add Exercise", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                AddExerciseSheet()
            }
        }
    }

    private func deleteExercises(offsets: IndexSet) {
        withAnimation {
            let exercises = offsets.map { filteredExercises[$0] }
            exercises.forEach(modelContext.delete)
        }
    }
}

fileprivate struct NoExercises: View {
    let searchQuery: String

    var body: some View {
        ContentUnavailableView(
            "No Exercises",
            systemImage: "dumbbell",
            description: Text(searchQuery.isEmpty ? "Add exercises to your library to get started" : "No exercises match '\(searchQuery)'")
        )
    }
}

fileprivate struct ExerciseListItem: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(exercise.name)
                .font(.headline)

            if !exercise.muscleGroups.isEmpty {
                Text(exercise.muscleGroups.map { $0.rawValue }.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("With Exercises") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)

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

    return ExerciseListScreen()
        .modelContainer(container)
}

#Preview("Empty List") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)

    return ExerciseListScreen()
        .modelContainer(container)
}
