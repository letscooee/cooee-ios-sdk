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
 - Since: 1.3.0
 */
class BaseElement: HandyJSON {
    // MARK: Lifecycle

    required init() {}

    init(_ background: Background?, _ clickAction: ClickAction) {
        self.bg = background
        self.clc = clickAction
    }

    // MARK: Public

    public func getX(for viewWidth: CGFloat) -> CGFloat {

        if viewWidth > UIScreen.main.bounds.width {
            let calculatedExtraSpace = viewWidth - UIScreen.main.bounds.width

            return (getX() + (calculatedExtraSpace / 2))
        }

        return x == nil ? 0 : UnitUtil.getScaledPixel(x!)
    }

    public func getY(for viewHeight: CGFloat) -> CGFloat {
        if viewHeight > UIScreen.main.bounds.height {
            let safeArea = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.filter({ $0.isKeyWindow }).first?.safeAreaInsets
            let safeAreaTop = safeArea?.top ?? 40
            let safeAreaBottom = safeArea?.bottom ?? 40
            let calculatedExtraSpace = viewHeight - UIScreen.main.bounds.height

            if safeAreaTop > 20 {
                return (getY() + (calculatedExtraSpace / 2)) + (safeAreaBottom + safeAreaTop)
            }

            return (getY() + (calculatedExtraSpace / 2))
        }

        return y == nil ? 0 : UnitUtil.getScaledPixel(y!)
    }

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

    public func getSpacing() -> Spacing {
        spc ?? Spacing()
    }

    // MARK: Internal

    var bg: Background?     // Background
    var br: Border?         // Border
    var shd: Shadow?        // Shadow
    var spc: Spacing?       // Spacing
    var trf: Transform?     // Transform
    var clc: ClickAction?   // ClickAction

    // MARK: Private

    private var t: Int?     // Type
    private var x: Float?   // X position
    private var y: Float?   // Y position
    private var z: Float?   // Z index
    private var w: Float?   // Width
    private var h: Float?   // Height
}
