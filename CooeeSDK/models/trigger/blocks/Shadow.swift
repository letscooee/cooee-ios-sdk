//
//  Shadow.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON
import UIKit
import SwiftUI

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Shadow: HandyJSON {

    private var elevation: Int?
    private var colour: Colour?
    private var xOffset: Int?
    private var yOffset: Int?

    public func getColour() -> Color {
        return colour?.getSwiftUIColour() ?? Color.black
    }

    public func getElevation() -> Int {
        print("Shadow Info: \(elevation) and scaled: \(UnitUtil.getScaledPixel(Float(elevation ?? 0)))")
        return Int(UnitUtil.getScaledPixel(Float(elevation ?? 0)))
    }

    public func getXOffset() -> CGFloat {
        UnitUtil.getScaledPixel(Float(xOffset ?? 0))
    }

    public func getYOffset() -> CGFloat {
        UnitUtil.getScaledPixel(Float(yOffset ?? 0))
    }

    mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &elevation, name: "spr")
        mapper.specify(property: &colour, name: "clr")
        mapper.specify(property: &xOffset, name: "x")
        mapper.specify(property: &yOffset, name: "y")
    }
}
