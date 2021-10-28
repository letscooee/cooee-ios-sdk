//
//  Size.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON
import FlexLayout
import UIKit

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Size: HandyJSON {
    // MARK: Lifecycle

    init() {
        self.display = Display.BLOCK
    }

    // MARK: Public

    public enum Display: String, HandyJSONEnum {
        case BLOCK, INLINE_BLOCK, FLEX, INLINE_FLEX
    }

    // MARK: Internal

    public func isDisplayFlex() -> Bool {
        (self.display == Display.FLEX || self.display == Display.INLINE_FLEX)
    }

    private var width: String?
    var height: String?
    var maxWidth: String?
    var maxHeight: String?
    var display: Display?
    private var justifyContent: FlexProperty.JustifyContent?
    private var alignItems: FlexProperty.AlignItems?
    private var wrap: FlexProperty.Wrap?
    private var alignContent: FlexProperty.AlignContent?
    private var direction: FlexProperty.Direction?

    func getDirection() -> Flex.Direction {
        direction?.description ?? FlexProperty.Direction.ROW.description
    }

    func getAlignItem() -> Flex.AlignItems {
        alignItems?.description ?? FlexProperty.AlignItems.STRETCH.description
    }

    func getWrap() -> Flex.Wrap {
        wrap?.description ?? FlexProperty.Wrap.NOWRAP.description
    }

    func getJustifyContent() -> Flex.JustifyContent {
        justifyContent?.description ?? FlexProperty.JustifyContent.FLEX_START.description
    }

    func getAlignContent() -> Flex.AlignContent {
        alignContent?.description ?? FlexProperty.AlignContent.STRETCH.description
    }

    public func getCalculatedWidth(_ parent: UIView) -> CGFloat? {
        width != nil ? CGFloat(UnitUtil.getCalculatedValue(parent, width!)) : nil
    }

    public func getCalculatedHeight(_ parent: UIView) -> CGFloat? {
        height != nil ? CGFloat(UnitUtil.getCalculatedValue(parent, height!, true)) : nil
    }

    public func getCalculatedMaxWidth(_ parent: UIView) -> CGFloat? {
        maxWidth != nil ? CGFloat(UnitUtil.getCalculatedValue(parent, maxWidth!)) : nil
    }

    public func getCalculatedMaxHeight(_ parent: UIView) -> CGFloat? {
        maxHeight != nil ? CGFloat(UnitUtil.getCalculatedValue(parent, maxHeight!, true)) : nil
    }
}
