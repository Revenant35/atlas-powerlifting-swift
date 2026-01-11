//
//  WorkoutProgram.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation
import SwiftData

@Model
final class WorkoutProgram {
    var name: String
    var programDescription: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Workout.program)
    var workouts: [Workout] = []

    init(name: String, programDescription: String) {
        self.name = name
        self.programDescription = programDescription
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    func updateTimestamp() {
        self.updatedAt = Date()
    }
    
    static let minWeeks = 1
    static let maxWeeks = 12
}
