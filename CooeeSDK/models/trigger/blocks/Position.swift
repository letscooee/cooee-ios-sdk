//
//  Position.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Position: Codable {
    // MARK: Lifecycle

    init() {
        self.type = PositionType.STATIC
    }

    // MARK: Public

    public enum PositionType: Codable {
        case STATIC, ABSOLUTE, FIXED
    }

    // MARK: Internal

    var type: PositionType? = nil
    var top: String? = nil
    var left: String? = nil
    var bottom: String? = nil
    var right: String? = nil
}
