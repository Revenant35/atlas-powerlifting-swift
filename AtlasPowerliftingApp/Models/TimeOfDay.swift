//
//  TimeOfDay.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation

enum TimeOfDay: String, Codable, CaseIterable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
}
