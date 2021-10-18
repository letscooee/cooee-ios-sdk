//
//  Gradient.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Gradient: Codable {
    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        type = try values.decode(Type.self, forKey: .type)
        c1 = try values.decode(String.self, forKey: .c1)
        c2 = try values.decode(String.self, forKey: .c2)
        c3 = try values.decode(String.self, forKey: .c3)
        c4 = try values.decode(String.self, forKey: .c4)
        c5 = try values.decode(String.self, forKey: .c5)
    }

    // MARK: Internal

    enum `Type`: Codable {
        case LINEAR
        case RADIAL
        case SWEEP
    }

    enum CodingKeys: String, CodingKey {
        case type, c1, c2, c3, c4, c5
    }

    let type: Type
    let c1: String?
    let c2: String?
    let c3: String?
    let c4: String?
    let c5: String?

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(c1, forKey: .c1)
        try container.encode(c2, forKey: .c2)
        try container.encode(c3, forKey: .c3)
        try container.encode(c4, forKey: .c4)
        try container.encode(c5, forKey: .c5)
    }
}
