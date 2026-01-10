//
//  WorkoutCard.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI

struct WorkoutCard: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with name and time badge
            HStack {
                Text(workout.name)
                    .font(.title3)
                    .fontWeight(.semibold)

                Spacer()

                if let timeOfDay = workout.timeOfDay {
                    Text(timeOfDay.rawValue)
                        .font(.subheadline)
//                        .foregroundStyle(.accent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.1))
                        .clipShape(Capsule())
                }
            }

            // Description (if present)
            if !workout.workoutDescription.isEmpty {
                Text(workout.workoutDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()

            // Inline exercises list
            WorkoutExercisesList(workoutExercises: workout.exercises)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    let workout = Workout(
        name: "Workout A",
        workoutDescription: "Focus on compound movements with progressive overload",
        week: 1,
        dayOfWeek: .monday,
        timeOfDay: .morning
    )

    let exercise1 = Exercise(name: "Squat", exerciseDescription: "Barbell back squat", muscleGroups: [.quads, .glutes])
    let exercise2 = Exercise(name: "Bench Press", exerciseDescription: "Barbell bench press", muscleGroups: [.chest, .triceps])

    let workoutExercise1 = WorkoutExercise(
        exercise: exercise1,
        order: 1,
        restTime: 180,
        warmupSets: 2,
        workout: workout
    )
    let workoutExercise2 = WorkoutExercise(
        exercise: exercise2,
        order: 2,
        restTime: 120,
        warmupSets: 1,
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

    workoutExercise1.sets = [set1, set2]

    return NavigationStack {
        ScrollView {
            WorkoutCard(workout: workout)
                .padding()
        }
    }
}
