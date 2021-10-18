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
    // MARK: Public

    public enum PositionType: Codable {
        case STATIC, ABSOLUTE, FIXED
    }

    // MARK: Internal

    var type: PositionType? = PositionType.STATIC
    let top: String?
    let left: String?
    let bottom: String?
    let right: String?
}
