//
//  BaseElement.swift
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
class BaseElement: HandyJSON {
    // MARK: Lifecycle

    required init() {}

    // MARK: Internal

    var bg: Background?
    var border: Border?
    var overflow: Overflow?
    var position: Position?
    var shadow: Shadow?
    var size: Size?
    var spacing: Spacing?
    var transform: Transform?
    var flexGrow: Int?
    var flexShrink: Int?
    var flexOrder: Int?
}
