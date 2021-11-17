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

    var type: PositionType?
    var top: String? = nil
    var left: String? = nil
    var bottom: String? = nil
    var right: String? = nil
}
