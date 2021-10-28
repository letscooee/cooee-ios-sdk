//
//  Gradient.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Gradient: HandyJSON {
    // MARK: Public

    public enum `Type`: String, HandyJSONEnum {
        case LINEAR
        case RADIAL
        case SWEEP
    }

    // MARK: Internal

    var type: Type?
    var c1: String?
    var c2: String?
    var c3: String?
    var c4: String?
    var c5: String?
}
