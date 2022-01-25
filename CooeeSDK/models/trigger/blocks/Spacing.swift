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

    // MARK: Private

    private var p: Float?
    private var pl: Float?
    private var pr: Float?
    private var pt: Float?
    private var pb: Float?

    private var calculatedPadding: CGFloat = 0
}
