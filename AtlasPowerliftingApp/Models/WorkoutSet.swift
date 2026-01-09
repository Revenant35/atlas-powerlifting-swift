//
//  WorkoutSet.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation
import SwiftData

@Model
final class WorkoutSet {
    var order: Int
    var reps: RepType
    var load: Load
    var intensity: Intensity?

    var workoutExercise: WorkoutExercise?

    init(order: Int, reps: RepType, load: Load, intensity: Intensity? = nil, workoutExercise: WorkoutExercise? = nil) {
        self.order = order
        self.reps = reps
        self.load = load
        self.intensity = intensity
        self.workoutExercise = workoutExercise
    }
}
