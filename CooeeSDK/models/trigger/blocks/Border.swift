//
//  Border.swift
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
struct Border: HandyJSON {
    // MARK: Public

    public enum Style {
        case SOLID, DASH
    }

    // MARK: Internal

    private var radius: String?
    private var width: String?
    private var dashWidth: String?
    private var dashGap: String?
    private var colour: Colour?
    private var style: Style?

    public func getWidth(_ parent: UIView) -> CGFloat {
        return width != nil ? UnitUtil.getCalculatedValue(parent, width!) : 0
    }

    public func getRadius(_ parent: UIView) -> CGFloat {
        return radius != nil ? UnitUtil.getCalculatedPixel(radius!) : 0
    }

    public func getDashWidth(_ parent: UIView) -> CGFloat {
        return dashWidth != nil ? UnitUtil.getCalculatedPixel(dashWidth!) : 0
    }

    public func getDashGap(_ parent: UIView) -> CGFloat {
        return dashGap != nil ? UnitUtil.getCalculatedPixel(dashGap!) : 0
    }

    public func getColour() -> UIColor? {
        return colour?.getColour()
    }

    public func getStyle() -> Style {
        return style ?? Style.SOLID
    }
}
