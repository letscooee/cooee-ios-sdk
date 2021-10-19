//
//  Alignment.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 19/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Alignment: Codable {
    // MARK: Public

    public enum Direction: Codable {
        case LTR, RTL
    }

    // MARK: Internal

    var align: TextAlignment? = TextAlignment.CENTER
    var direction: Direction? = Direction.LTR
}
