//
//  DayOfWeek.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation

enum DayOfWeek: String, Codable, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"

    var sortOrder: Int {
        switch self {
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        case .sunday: return 7
        }
    }
}

extension DayOfWeek: Comparable {
    static func < (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}
