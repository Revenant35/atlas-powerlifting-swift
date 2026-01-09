//
//  WorkoutsList.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI

struct WorkoutsList: View {
    let workouts: [Workout]

    private var sortedWorkouts: [Workout] {
        workouts.sorted { w1, w2 in
            if w1.week != w2.week {
                return w1.week < w2.week
            }
            if w1.dayOfWeek != w2.dayOfWeek {
                return w1.dayOfWeek < w2.dayOfWeek
            }
            // Handle optional timeOfDay - nil comes first
            switch (w1.timeOfDay, w2.timeOfDay) {
            case (nil, nil): return false
            case (nil, _): return true
            case (_, nil): return false
            case let (t1?, t2?): return t1 < t2
            }
        }
    }

    var body: some View {
        if sortedWorkouts.isEmpty {
            ContentUnavailableView(
                "No Workouts",
                systemImage: "figure.strengthtraining.traditional",
                description: Text("Add workouts to this program to get started")
            )
        } else {
            List {
                ForEach(sortedWorkouts) { workout in
                    NavigationLink {
                        WorkoutDetailsScreen(workoutID: workout.persistentModelID)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(workout.name)
                                .font(.headline)
                            HStack {
                                Text(workout.dayOfWeek.rawValue)
                                if let timeOfDay = workout.timeOfDay {
                                    Text("•")
                                    Text(timeOfDay.rawValue)
                                }
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}

#Preview("With Workouts") {
    let program = WorkoutProgram(name: "Starting Strength", programDescription: "")
    let workout1 = Workout(
        name: "Workout A",
        workoutDescription: "Squat, Bench, Deadlift",
        week: 1,
        dayOfWeek: .monday,
        timeOfDay: .morning,
        program: program
    )
    let workout2 = Workout(
        name: "Workout B",
        workoutDescription: "Squat, Press, Power Clean",
        week: 1,
        dayOfWeek: .wednesday,
        timeOfDay: .morning,
        program: program
    )
    let workout3 = Workout(
        name: "Workout A",
        workoutDescription: "Squat, Bench, Deadlift",
        week: 1,
        dayOfWeek: .friday,
        timeOfDay: .morning,
        program: program
    )

    return NavigationStack {
        WorkoutsList(workouts: [workout1, workout2, workout3])
            .navigationTitle("Workouts")
    }
}

#Preview("Empty") {
    NavigationStack {
        WorkoutsList(workouts: [])
            .navigationTitle("Workouts")
    }
}
