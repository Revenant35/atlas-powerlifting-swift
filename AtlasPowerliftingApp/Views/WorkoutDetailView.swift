//
//  WorkoutDetailView.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        Text("Workout: \(workout.name)")
            .navigationTitle(workout.name)
    }
}

#Preview {
    let workout = Workout(
        name: "Workout A",
        workoutDescription: "Squat, Bench, Deadlift",
        week: 1,
        dayOfWeek: .monday,
        timeOfDay: .morning
    )

    return NavigationStack {
        WorkoutDetailView(workout: workout)
    }
}
