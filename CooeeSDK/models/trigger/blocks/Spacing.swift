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
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Spacing: HandyJSON {

    private var p: Float?
    private var pl: Float?
    private var pr: Float?
    private var pt: Float?
    private var pb: Float?

    private var calculatedPadding: CGFloat = 0

    public mutating func calculatedPaddingAndMargin(_ parent: UIView) {
        calculatedPadding = CGFloat(p == nil ? 0 : UnitUtil.getScaledPixel(p!))
    }

    public func getPaddingLeft(_ parent: UIView? = nil) -> CGFloat {
        return pl != nil ? UnitUtil.getScaledPixel(pl!) : calculatedPadding;
    }

    public func getPaddingRight(_ parent: UIView? = nil) -> CGFloat {
        return pr != nil ? UnitUtil.getScaledPixel(pr!) : calculatedPadding;
    }

    public func getPaddingTop(_ parent: UIView? = nil) -> CGFloat {
        return pt != nil ? UnitUtil.getScaledPixel(pt!) : calculatedPadding;
    }

    public func getPaddingBottom(_ parent: UIView? = nil) -> CGFloat {
        return pb != nil ? UnitUtil.getScaledPixel(pb!) : calculatedPadding;
    }
}
