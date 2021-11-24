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
    private var c: Colour?
    private var s: Int?

    public func getWidth(_ parent: UIView? = nil) -> CGFloat {
        return CGFloat(w ?? 0)
    }

    public func getRadius(_ parent: UIView? = nil) -> CGFloat {
        return CGFloat(r ?? 0)
    }

    public func getDashWidth(_ parent: UIView? = nil) -> CGFloat {
        return UnitUtil.getScaledPixel(dw!)
    }

    public func getDashGap(_ parent: UIView? = nil) -> CGFloat {
        return UnitUtil.getScaledPixel(dg!)
    }

    public func getColour() -> UIColor? {
        return c?.getColour()
    }

    public func getColour() -> String {
        return c?.h! ?? "#ffffff"
    }
    
    public func getAlpha() -> Double {
        return c?.getAlpha() ?? 100
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
