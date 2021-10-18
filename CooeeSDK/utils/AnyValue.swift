//
//  AnyValue.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation

public enum AnyValue: Codable {
    case int(Int), string(String), double(Double)

    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        if let dbl = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(dbl)
            return
        }

        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }

        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }

        throw QuantumError.missingValue
    }

    // MARK: Public

    public func encode(to encoder: Encoder) throws {}

    // MARK: Internal

    enum QuantumError: Error {
        case missingValue
    }

    var any: Any {
        switch self {
        case .double(let value):
            return value
        case .int(let value):
            return value
        case .string(let value):
            return value
        }
    }
}
