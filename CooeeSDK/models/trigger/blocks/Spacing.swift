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
    private var m: Float?
    private var mr: Float?
    private var ml: Float?
    private var mt: Float?
    private var mb: Float?

    private var calculatedMargin: CGFloat = 0
    private var calculatedPadding: CGFloat = 0

    public func getMarginLeft(_ parent: UIView) -> CGFloat {
        ml != nil ? UnitUtil.getScaledPixel(ml!) : calculatedMargin;
    }

    public func getMarginRight(_ parent: UIView) -> CGFloat {
        mr != nil ? UnitUtil.getScaledPixel(mr!) : calculatedMargin;
    }

    public func getMarginTop(_ parent: UIView) -> CGFloat {
        mt != nil ? UnitUtil.getScaledPixel(mt!) : calculatedMargin;
    }

    public func getMarginBottom(_ parent: UIView) -> CGFloat {
        mb != nil ? UnitUtil.getScaledPixel(mb!) : calculatedMargin;
    }

    public mutating func calculatedPaddingAndMargin(_ parent: UIView) {
        calculatedMargin = UnitUtil.getScaledPixel(m!)

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
