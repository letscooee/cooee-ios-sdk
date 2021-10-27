//
//  BaseElement.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class BaseElement: HandyJSON {
    // MARK: Lifecycle

    required init() {
    }

    // MARK: Internal

    private var type: ElementType?
    var bg: Background?
    var border: Border?
    var overflow: Overflow?
    var position: Position?
    var shadow: Shadow?
    private var size: Size?
    var spacing: Spacing?
    var transform: Transform?
    private var flexGrow: Int?
    private var flexShrink: Int?
    private var flexOrder: Int?

    public func getSize() -> Size {
        if size == nil {
            size = Size()
        }

        return size!
    }

    public func getFlexGrow() -> CGFloat? {
        if flexGrow != nil {
            return CGFloat(flexGrow!)
        }
        return nil
    }

    public func getFlexShrink() -> CGFloat? {
        if flexShrink != nil {
            return CGFloat(flexShrink!)
        }
        return nil
    }

    public func getFlexOrder() -> CGFloat? {
        if flexOrder != nil {
            return CGFloat(flexOrder!)
        }
        return nil
    }

    public func getElementType() -> ElementType {
        type ?? ElementType.TEXT
    }
}
