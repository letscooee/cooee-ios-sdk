//
//  Glossy.swift
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
struct Glossy: HandyJSON {

    private var r: Int?
    var s: Int?
    var clr: Colour?

    public func getRadius() -> CGFloat {
        CGFloat(r ?? 18)
    }
}
