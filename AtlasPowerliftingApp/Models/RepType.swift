//
//  RepType.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation

enum RepType: Codable, Equatable {
    case fixed(reps: Int)
    case amrap
    case range(min: Int, max: Int)

    enum CodingKeys: String, CodingKey {
        case kind
        case reps
        case min
        case max
    }

    enum Kind: String, Codable {
        case fixed
        case amrap
        case range
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)

        switch kind {
        case .fixed:
            let reps = try container.decode(Int.self, forKey: .reps)
            guard reps > 0 else {
                throw DecodingError.dataCorruptedError(forKey: .reps, in: container, debugDescription: "reps must be positive")
            }
            self = .fixed(reps: reps)
        case .amrap:
            self = .amrap
        case .range:
            let min = try container.decode(Int.self, forKey: .min)
            let max = try container.decode(Int.self, forKey: .max)
            guard min > 0 && max > 0 else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.min], debugDescription: "min and max must be positive"))
            }
            guard min < max else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.min], debugDescription: "min must be less than max"))
            }
            self = .range(min: min, max: max)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .fixed(let reps):
            try container.encode(Kind.fixed, forKey: .kind)
            try container.encode(reps, forKey: .reps)
        case .amrap:
            try container.encode(Kind.amrap, forKey: .kind)
        case .range(let min, let max):
            try container.encode(Kind.range, forKey: .kind)
            try container.encode(min, forKey: .min)
            try container.encode(max, forKey: .max)
        }
    }
}
