//
//  WorkoutDetailsScreen.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct WorkoutDetailsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var workout: Workout

    var body: some View {
        VStack(spacing: 0) {
            // Workout info header
            VStack(alignment: .leading, spacing: 12) {
                if !workout.workoutDescription.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(workout.workoutDescription)
                            .font(.body)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Schedule")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack {
                        Label("Week \(workout.week)", systemImage: "calendar")
                        Spacer()
                        Label(workout.dayOfWeek.rawValue, systemImage: "calendar.day.timeline.leading")
                        Spacer()
                        Label(workout.timeOfDay.rawValue, systemImage: "clock")
                    }
                    .font(.body)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGroupedBackground))

            WorkoutExercisesList(workoutExercises: workout.exercises)
        }
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addExercise) {
                    Label("Add Exercise", systemImage: "plus")
                }
            }
        }
    }

    private func addExercise() {
        withAnimation {
            // Get the next order number
            let nextOrder = (workout.exercises.map { $0.order }.max() ?? 0) + 1

            let newWorkoutExercise = WorkoutExercise(
                exercise: nil,
                order: nextOrder,
                restTime: 90,
                warmupSets: 0,
                workout: workout
            )
            modelContext.insert(newWorkoutExercise)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: WorkoutProgram.self, Workout.self, Exercise.self, WorkoutExercise.self, WorkoutSet.self,
        configurations: config
    )

    let program = WorkoutProgram(name: "Starting Strength", programDescription: "")
    let workout = Workout(
        name: "Workout A",
        workoutDescription: "Focus on compound movements with progressive overload",
        week: 1,
        dayOfWeek: .monday,
        timeOfDay: .morning,
        program: program
    )

    let squat = Exercise(name: "Squat", exerciseDescription: "Barbell back squat", muscleGroups: [.quads, .glutes])
    let bench = Exercise(name: "Bench Press", exerciseDescription: "Barbell bench press", muscleGroups: [.chest, .triceps])
    let deadlift = Exercise(name: "Deadlift", exerciseDescription: "Conventional deadlift", muscleGroups: [.back, .hamstrings])

    let we1 = WorkoutExercise(exercise: squat, order: 1, restTime: 180, warmupSets: 2, workout: workout)
    let we2 = WorkoutExercise(exercise: bench, order: 2, restTime: 120, warmupSets: 1, workout: workout)
    let we3 = WorkoutExercise(exercise: deadlift, order: 3, restTime: 240, warmupSets: 2, workout: workout)

    let set1 = WorkoutSet(order: 1, reps: .fixed(reps: 5), load: .absolute(weightKG: 100), workoutExercise: we1)
    let set2 = WorkoutSet(order: 2, reps: .fixed(reps: 5), load: .absolute(weightKG: 100), workoutExercise: we1)
    let set3 = WorkoutSet(order: 3, reps: .fixed(reps: 5), load: .absolute(weightKG: 100), workoutExercise: we1)

    container.mainContext.insert(program)
    container.mainContext.insert(workout)
    container.mainContext.insert(squat)
    container.mainContext.insert(bench)
    container.mainContext.insert(deadlift)
    container.mainContext.insert(we1)
    container.mainContext.insert(we2)
    container.mainContext.insert(we3)
    container.mainContext.insert(set1)
    container.mainContext.insert(set2)
    container.mainContext.insert(set3)

    return NavigationStack {
        WorkoutDetailsScreen(workout: workout)
    }
    .modelContainer(container)
}
