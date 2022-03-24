//
//  Spacing.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON
import UIKit

/**
 Handles the padding of the element

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct Spacing: HandyJSON {
    // MARK: Public

    /**
     Calculates scaled left padding and provide result
     In case if ``pl`` is nil, process ``p`` and if ``p`` is also nil
     then process for 0
     Also adds ``value`` to the padding

     - Parameter value: value to be added in padding
     - Returns: padding in ``CGFloat``
     */
    public func getPaddingLeft(add value: CGFloat = 0) -> CGFloat {
        let padding = UnitUtil.getScaledPixel(pl ?? p ?? 0)
        return padding == 0 ? value : padding
    }

    /**
     Calculates scaled right padding and provide result
     In case if ``pr`` is nil, process ``p`` and if ``p`` is also nil
     then process for 0
     Also adds ``value`` to the padding

     - Parameter value: value to be added in padding
     - Returns: padding in ``CGFloat``
     */
    public func getPaddingRight(add value: CGFloat = 0) -> CGFloat {
        let padding = UnitUtil.getScaledPixel(pr ?? p ?? 0)
        return padding == 0 ? value : padding
    }

    /**
     Calculates scaled top padding and provide result
     In case if ``pt`` is nil, process ``p`` and if ``p`` is also nil
     then process for 0
     Also adds ``value`` to the padding

     - Parameter value: value to be added in padding
     - Returns: padding in ``CGFloat``
     */
    public func getPaddingTop(add value: CGFloat = 0) -> CGFloat {
        let padding = UnitUtil.getScaledPixel(pt ?? p ?? 0)
        return padding == 0 ? value : padding
    }

    /**
     Calculates scaled bottom padding and provide result
     In case if ``pb`` is nil, process ``p`` and if ``p`` is also nil
     then process for 0
     Also adds ``value`` to the padding

     - Parameter value: value to be added in padding
     - Returns: padding in ``CGFloat``
     */
    public func getPaddingBottom(add value: CGFloat = 0) -> CGFloat {
        let padding = UnitUtil.getScaledPixel(pb ?? p ?? 0)
        return padding == 0 ? value : padding
    }

    /**
     Calculates scaled  padding depending on  and provide result
     In case if ``pl`` is nil, process ``p`` and if ``p`` is also nil
     then process for 0
     Also check of the value is greater than 0 then return 0, Otherwise return the value

     - Parameter side: side of the padding
     - Parameter value: value to replace the padding
     - Returns: padding in ``CGFloat``
     */
    public func applyPaddingWRTBorder(_ side: PaddingSide, replaceWith value: CGFloat = 0) -> CGFloat {
        var padding: Float? = 0
        switch (side) {
            case .left:
                padding = pl
            case .right:
                padding = pr
            case .top:
                padding = pt
            case .bottom:
                padding = pb
        }

        return UnitUtil.getScaledPixel(padding ?? p ?? 0) > 0 ? 0 : value
    }

    enum PaddingSide {
        case left
        case right
        case top
        case bottom
    }

    // MARK: Private

    private var p: Float?
    private var pl: Float?
    private var pr: Float?
    private var pt: Float?
    private var pb: Float?

    private var calculatedPadding: CGFloat = 0
}
