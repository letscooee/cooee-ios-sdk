//
//  Position.swift
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
struct Position: HandyJSON {
    // MARK: Lifecycle

//    init() {
//        self.type = PositionType.STATIC
//        su
//    }

    // MARK: Public

    public enum PositionType {
        case STATIC, ABSOLUTE, FIXED
    }

    // MARK: Internal

    var type: PositionType?
    var top: String? = nil
    var left: String? = nil
    var bottom: String? = nil
    var right: String? = nil
}
