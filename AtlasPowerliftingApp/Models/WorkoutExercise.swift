//
//  WorkoutExercise.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation
import SwiftData

@Model
final class WorkoutExercise {
    var order: Int
    var restTime: Int // in seconds
    var warmupSets: Int
    var notes: String

    var exercise: Exercise?
    var workout: Workout?

    @Relationship(deleteRule: .cascade, inverse: \WorkoutSet.workoutExercise)
    var sets: [WorkoutSet] = []

    init(exercise: Exercise?, order: Int, restTime: Int = 90, warmupSets: Int = 0, notes: String = "", workout: Workout? = nil) {
        self.exercise = exercise
        self.order = order
        self.restTime = restTime
        self.warmupSets = warmupSets
        self.notes = notes
        self.workout = workout
    }
}
