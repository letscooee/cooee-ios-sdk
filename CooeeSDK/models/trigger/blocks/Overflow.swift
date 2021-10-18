//
//  Overflow.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Overflow: Codable {
    // MARK: Public

    public enum `Type`: Codable {
        case VISIBLE, HIDDEN
    }

    // MARK: Internal

    let x: Type?
    let y: Type?
}
