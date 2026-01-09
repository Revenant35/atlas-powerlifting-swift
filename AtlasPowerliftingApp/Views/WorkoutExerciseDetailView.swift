//
//  WorkoutExerciseDetailView.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI

struct WorkoutExerciseDetailView: View {
    let workoutExercise: WorkoutExercise

    var body: some View {
        Text("Exercise: \(workoutExercise.exercise?.name ?? "Unknown")")
            .navigationTitle(workoutExercise.exercise?.name ?? "Exercise")
    }
}

#Preview {
    let exercise = Exercise(name: "Squat", exerciseDescription: "Barbell back squat", muscleGroups: [.quads])
    let workoutExercise = WorkoutExercise(exercise: exercise, order: 1, restTime: 180, warmupSets: 2)

    return NavigationStack {
        WorkoutExerciseDetailView(workoutExercise: workoutExercise)
    }
}
