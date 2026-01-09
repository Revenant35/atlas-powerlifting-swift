//
//  Intensity.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import Foundation

enum Intensity: Codable, Equatable {
    case rpe(value: Double)
    case rir(value: Int)

    enum CodingKeys: String, CodingKey {
        case kind
        case value
    }

    enum Kind: String, Codable {
        case RPE
        case RIR
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)

        switch kind {
        case .RPE:
            let value = try container.decode(Double.self, forKey: .value)
            guard value >= 0 && value <= 10 else {
                throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "RPE value must be between 0 and 10")
            }
            self = .rpe(value: value)
        case .RIR:
            let value = try container.decode(Int.self, forKey: .value)
            guard value >= 0 && value <= 12 else {
                throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "RIR value must be between 0 and 12")
            }
            self = .rir(value: value)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .rpe(let value):
            try container.encode(Kind.RPE, forKey: .kind)
            try container.encode(value, forKey: .value)
        case .rir(let value):
            try container.encode(Kind.RIR, forKey: .kind)
            try container.encode(value, forKey: .value)
        }
    }
}
