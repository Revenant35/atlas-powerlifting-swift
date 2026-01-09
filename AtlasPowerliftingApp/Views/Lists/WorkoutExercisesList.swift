//
//  WorkoutExercisesList.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI

struct WorkoutExercisesList: View {
    let workoutExercises: [WorkoutExercise]

    private var sortedExercises: [WorkoutExercise] {
        workoutExercises.sorted { $0.order < $1.order }
    }

    var body: some View {
        if sortedExercises.isEmpty {
            ContentUnavailableView(
                "No Exercises",
                systemImage: "dumbbell",
                description: Text("Add exercises to this workout to get started")
            )
        } else {
            List {
                ForEach(sortedExercises) { workoutExercise in
                    NavigationLink {
                        WorkoutExerciseDetailView(workoutExercise: workoutExercise)
                    } label: {
                        HStack {
                            Text("\(workoutExercise.order)")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .frame(width: 30, alignment: .leading)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(workoutExercise.exercise?.name ?? "Unknown Exercise")
                                    .font(.headline)

                                HStack {
                                    Text("\(workoutExercise.sets.count) sets")
                                    if workoutExercise.warmupSets > 0 {
                                        Text("•")
                                        Text("\(workoutExercise.warmupSets) warmup")
                                    }
                                    Text("•")
                                    Text("\(workoutExercise.restTime)s rest")
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}

#Preview("With Exercises") {
    let squat = Exercise(name: "Squat", exerciseDescription: "Barbell back squat", muscleGroups: [.quads, .glutes])
    let bench = Exercise(name: "Bench Press", exerciseDescription: "Barbell bench press", muscleGroups: [.chest, .triceps])
    let deadlift = Exercise(name: "Deadlift", exerciseDescription: "Conventional deadlift", muscleGroups: [.back, .hamstrings])

    let we1 = WorkoutExercise(exercise: squat, order: 1, restTime: 180, warmupSets: 2)
    let we2 = WorkoutExercise(exercise: bench, order: 2, restTime: 120, warmupSets: 1)
    let we3 = WorkoutExercise(exercise: deadlift, order: 3, restTime: 240, warmupSets: 2)

    // Add some sets
    let set1 = WorkoutSet(order: 1, reps: .fixed(reps: 5), load: .absolute(weightKG: 100), workoutExercise: we1)
    let set2 = WorkoutSet(order: 2, reps: .fixed(reps: 5), load: .absolute(weightKG: 100), workoutExercise: we1)
    let set3 = WorkoutSet(order: 3, reps: .fixed(reps: 5), load: .absolute(weightKG: 100), workoutExercise: we1)

    return NavigationStack {
        WorkoutExercisesList(workoutExercises: [we1, we2, we3])
            .navigationTitle("Exercises")
    }
}

#Preview("Empty") {
    NavigationStack {
        WorkoutExercisesList(workoutExercises: [])
            .navigationTitle("Exercises")
    }
}
