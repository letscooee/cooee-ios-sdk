//
//  Shadow.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON
import UIKit

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Shadow: HandyJSON {

    private var e: Int?
    private var clr: Colour?

    public func getColour() -> UIColor {
        return clr?.getColour() ?? UIColor.black
    }

    public func getElevation() -> Int {
        return e ?? 0
    }
}
