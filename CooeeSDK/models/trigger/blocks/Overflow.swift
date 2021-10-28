//
//  Overflow.swift
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
struct Overflow: HandyJSON {
    // MARK: Public

    public enum `Type`: String, HandyJSONEnum {
        case VISIBLE, HIDDEN
    }

    // MARK: Internal

    var x: Type?
    var y: Type?
}
