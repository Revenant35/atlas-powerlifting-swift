//
//  Workout.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation
import SwiftData

@Model
final class Workout {
    var name: String
    var workoutDescription: String
    var week: Int
    var dayOfWeek: DayOfWeek
    var timeOfDay: TimeOfDay

    var program: WorkoutProgram?

    @Relationship(deleteRule: .cascade, inverse: \WorkoutExercise.workout)
    var exercises: [WorkoutExercise] = []

    init(name: String, workoutDescription: String, week: Int, dayOfWeek: DayOfWeek, timeOfDay: TimeOfDay, program: WorkoutProgram? = nil) {
        self.name = name
        self.workoutDescription = workoutDescription
        self.week = week
        self.dayOfWeek = dayOfWeek
        self.timeOfDay = timeOfDay
        self.program = program
    }
}
