//
//  Border.swift
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
struct Border: HandyJSON {
    // MARK: Public

    public enum Style: String, HandyJSONEnum {
        case SOLID, DASH
    }

    // MARK: Internal

    private var radius: Float?
    private var width: Float?
    private var dashWidth: Float?
    private var dashGap: Float?
    private var colour: Colour?
    private var style: Style?

    public func getWidth(_ parent: UIView? = nil) -> CGFloat {
        return width == nil ? 0 : UnitUtil.getScaledPixel(width!)
    }

    public func getRadius(_ parent: UIView? = nil) -> CGFloat {
        return radius == nil ? 0 : UnitUtil.getScaledPixel(radius!)
    }

    public func getDashWidth(_ parent: UIView? = nil) -> CGFloat {
        return UnitUtil.getScaledPixel(dashWidth!)
    }

    public func getDashGap(_ parent: UIView? = nil) -> CGFloat {
        return UnitUtil.getScaledPixel(dashGap!)
    }

    public func getColour() -> UIColor? {
        return colour?.getColour()
    }

    public func getColour() -> String {
        return colour?.hex! ?? "#ffffff"
    }

    public func getStyle() -> Style {
        return style ?? Style.SOLID
    }
}
