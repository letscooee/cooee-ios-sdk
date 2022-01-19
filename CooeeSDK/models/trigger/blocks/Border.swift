//
//  Border.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON
import SwiftUI
import UIKit

/**
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct Border: HandyJSON {
    // MARK: Public

    public enum Style: String, HandyJSONEnum {
        case SOLID, DASH
    }

    public func getWidth(_ parent: UIView? = nil) -> CGFloat {
        return UnitUtil.getScaledPixel(w ?? 0)
    }

    public func getRadius(_ parent: UIView? = nil) -> CGFloat {
        return UnitUtil.getScaledPixel(r ?? 0)
    }

    public func getDashWidth(_ parent: UIView? = nil) -> CGFloat {
        let value = UnitUtil.getScaledPixel(dw ?? 0) * 2
        return  value < 10 ? 10 : value
    }

    public func getDashGap(_ parent: UIView? = nil) -> CGFloat {
        let value = UnitUtil.getScaledPixel(dg ?? 0)
        return  value < 10 ? 10 : value
    }

    public func getColour() -> UIColor? {
        return c?.getColour()
    }

    public func getColour() -> String {
        return c?.getColour() ?? "#000000"
    }

    public func getAlpha() -> Double {
        return c?.getAlpha() ?? 100
    }

    public func getStyle() -> Style {
        switch s {
        case 1:
            return Style.SOLID
        case 2:
            return Style.DASH
        case .none:
            return Style.SOLID
        case .some:
            return Style.SOLID
        }
    }

    // MARK: Private

    private var r: Float?
    private var w: Float?
    private var dw: Float?
    private var dg: Float?
    private var c: Colour?
    private var s: Int?
}
