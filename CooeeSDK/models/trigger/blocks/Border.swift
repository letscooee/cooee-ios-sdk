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

    private var r: Float?
    private var w: Float?
    private var dw: Float?
    private var dg: Float?
    private var clr: Colour?
    private var s: Int?

    public func getWidth(_ parent: UIView? = nil) -> CGFloat {
        return w == nil ? 0 : UnitUtil.getScaledPixel(w!)
    }

    public func getRadius(_ parent: UIView? = nil) -> CGFloat {
        return r == nil ? 0 : UnitUtil.getScaledPixel(r!)
    }

    public func getDashWidth(_ parent: UIView? = nil) -> CGFloat {
        return UnitUtil.getScaledPixel(dw!)
    }

    public func getDashGap(_ parent: UIView? = nil) -> CGFloat {
        return UnitUtil.getScaledPixel(dg!)
    }

    public func getColour() -> UIColor? {
        return clr?.getColour()
    }

    public func getColour() -> String {
        return clr?.h! ?? "#ffffff"
    }

    public func getStyle() -> Style {
        switch (s) {
        case 1:
            return Style.SOLID
        case 2:
            return Style.DASH
        case .none:
            return Style.SOLID
        case .some(_):
            return Style.SOLID
        }
    }
}
