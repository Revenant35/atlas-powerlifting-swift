//
//  Load.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation

enum Load: Codable, Equatable {
    case absolute(weightKG: Double)
    case bodyweight(deltaKG: Double)
    case percent1RM(percent: Double)

    enum CodingKeys: String, CodingKey {
        case kind
        case weightKG
        case deltaKG
        case percent
    }

    enum Kind: String, Codable {
        case absolute
        case bodyweight
        case percent_1rm
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)

        switch kind {
        case .absolute:
            let weightKG = try container.decode(Double.self, forKey: .weightKG)
            guard weightKG >= 0 else {
                throw DecodingError.dataCorruptedError(forKey: .weightKG, in: container, debugDescription: "weightKG must be non-negative")
            }
            self = .absolute(weightKG: weightKG)
        case .bodyweight:
            let deltaKG = try container.decodeIfPresent(Double.self, forKey: .deltaKG) ?? 0
            self = .bodyweight(deltaKG: deltaKG)
        case .percent_1rm:
            let percent = try container.decode(Double.self, forKey: .percent)
            guard percent >= 0 && percent <= 1 else {
                throw DecodingError.dataCorruptedError(forKey: .percent, in: container, debugDescription: "percent must be between 0 and 1")
            }
            self = .percent1RM(percent: percent)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .absolute(let weightKG):
            try container.encode(Kind.absolute, forKey: .kind)
            try container.encode(weightKG, forKey: .weightKG)
        case .bodyweight(let deltaKG):
            try container.encode(Kind.bodyweight, forKey: .kind)
            try container.encode(deltaKG, forKey: .deltaKG)
        case .percent1RM(let percent):
            try container.encode(Kind.percent_1rm, forKey: .kind)
            try container.encode(percent, forKey: .percent)
        }
    }
}
