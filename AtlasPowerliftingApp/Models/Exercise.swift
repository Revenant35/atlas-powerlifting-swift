//
//  Exercise.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation
import SwiftData

@Model
final class Exercise {
    var name: String
    var exerciseDescription: String
    var muscleGroups: [MuscleGroup]
    var createdAt: Date
    var updatedAt: Date

    init(name: String, exerciseDescription: String, muscleGroups: [MuscleGroup] = []) {
        self.name = name
        self.exerciseDescription = exerciseDescription
        self.muscleGroups = muscleGroups
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    func updateTimestamp() {
        self.updatedAt = Date()
    }
}
