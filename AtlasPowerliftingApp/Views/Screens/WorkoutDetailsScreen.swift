//
//  WorkoutDetailsScreen.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct WorkoutDetailsScreen: View {
    @Bindable var workout: Workout

    var body: some View {
        Group {
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
                            if let timeOfDay = workout.timeOfDay {
                                Spacer()
                                Label(timeOfDay.rawValue, systemImage: "clock")
                            }
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
            
            workout.exercises.append(newWorkoutExercise)
        }
    }
}

#Preview {
    let workout = Workout(
        name: "Workout A",
        workoutDescription: "Focus on compound movements with progressive overload",
        week: 1,
        dayOfWeek: .monday,
        timeOfDay: .morning,
    )

    let exercise1 = Exercise(name: "Squat", exerciseDescription: "Barbell back squat", muscleGroups: [.quads, .glutes])
    let exercise2 = Exercise(name: "Bench Press", exerciseDescription: "Barbell bench press", muscleGroups: [.chest, .triceps])
    let exercise3 = Exercise(name: "Deadlift", exerciseDescription: "Conventional deadlift", muscleGroups: [.back, .hamstrings])

    let workoutExercise1 = WorkoutExercise(
        exercise: exercise1,
        order: 1,
        restTime: 180,
        warmupSets: 2,
        workout: workout
    )
    let workoutExercise2 = WorkoutExercise(
        exercise: exercise1,
        order: 2,
        restTime: 180,
        warmupSets: 2,
        workout: workout
    )
    let workoutExercise3 = WorkoutExercise(
        exercise: exercise2,
        order: 3,
        restTime: 120,
        warmupSets: 1,
        workout: workout
    )
    let workoutExercise4 = WorkoutExercise(
        exercise: exercise3,
        order: 4,
        restTime: 240,
        warmupSets: 2,
        workout: workout
    )
    

    let set1 = WorkoutSet(
        order: 1,
        reps: .fixed(reps: 5),
        load: .absolute(weightKG: 100),
        workoutExercise: workoutExercise1
    )

    let set2 = WorkoutSet(
        order: 2,
        reps: .fixed(reps: 5),
        load: .absolute(weightKG: 100),
        workoutExercise: workoutExercise1
    )

    let set3 = WorkoutSet(
        order: 3,
        reps: .fixed(reps: 5),
        load: .absolute(weightKG: 100),
        workoutExercise: workoutExercise1
    )
    
    workoutExercise1.sets = [set1, set2, set3]

    return NavigationStack {
        WorkoutDetailsScreen(workout: workout)
    }
}
