//
//  MuscleGroup.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation

enum MuscleGroup: String, Codable, CaseIterable {
    // Arms
    case biceps = "Biceps"
    case triceps = "Triceps"
    case forearms = "Forearms"

    // Chest
    case chest = "Chest"
    case upperChest = "Upper Chest"
    case lowerChest = "Lower Chest"

    // Shoulders
    case shoulders = "Shoulders"
    case frontDelts = "Front Delts"
    case sideDelts = "Side Delts"
    case rearDelts = "Rear Delts"

    // Back
    case back = "Back"
    case lats = "Lats"
    case traps = "Traps"
    case rhomboids = "Rhomboids"
    case lowerBack = "Lower Back"

    // Core
    case abs = "Abs"
    case obliques = "Obliques"

    // Legs
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case glutes = "Glutes"
    case calves = "Calves"
    case hipFlexors = "Hip Flexors"
    case adductors = "Adductors"
    case abductors = "Abductors"
}
