//
//  BaseElement.swift
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
class BaseElement: HandyJSON {
    // MARK: Lifecycle

    required init() {
    }

    // MARK: Public

    public func getX(_ parentView: UIView? = nil) -> CGFloat {
        return x == nil ? 0 : UnitUtil.getScaledPixel(x!)
    }

    public func getY(_ parentView: UIView? = nil) -> CGFloat {
        return y == nil ? 0 : UnitUtil.getScaledPixel(y!)
    }

    public func getCalculatedWidth() -> CGFloat? {
        return w == nil ? nil : UnitUtil.getScaledPixel(w!)
    }

    public func getCalculatedHeight() -> CGFloat? {
        return h == nil ? nil : UnitUtil.getScaledPixel(h!)
    }

    public func getElementType() -> ElementType {
        ElementType(rawValue: t!) ?? ElementType.SHAPE
    }

    public func getClickAction() -> ClickAction? {
        clc
    }

    // MARK: Internal

    var bg: Background?
    var br: Border?
    var shadow: Shadow?
    var spc: Spacing?
    var trf: Transform?
    var clc: ClickAction?

    // MARK: Private

    private var t: Int?
    private var x: Float?
    private var y: Float?
    private var z: Float?
    private var w: Float?
    private var h: Float?
}