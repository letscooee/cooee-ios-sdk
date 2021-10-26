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

    private var p: String?
    private var pl: String?
    private var pr: String?
    private var pt: String?
    private var pb: String?
    private var m: String?
    private var mr: String?
    private var ml: String?
    private var mt: String?
    private var mb: String?

    private var calculatedMargin: CGFloat = 0
    private var calculatedPadding: CGFloat = 0

    public func getMarginLeft(_ parent: UIView) -> CGFloat {
        ml != nil ? UnitUtil.getCalculatedValue(parent, ml!) : calculatedMargin;
    }

    public func getMarginRight(_ parent: UIView) -> CGFloat {
        mr != nil ? UnitUtil.getCalculatedValue(parent, mr!) : calculatedMargin;
    }

    public func getMarginTop(_ parent: UIView) -> CGFloat {
        mt != nil ? UnitUtil.getCalculatedValue(parent, mt!) : calculatedMargin;
    }

    public func getMarginBottom(_ parent: UIView) -> CGFloat {
        mb != nil ? UnitUtil.getCalculatedValue(parent, mb!) : calculatedMargin;
    }

    public mutating func calculatedPaddingAndMargin(_ parent: UIView) {
        calculatedMargin = CGFloat(m == nil ? 0 : UnitUtil.getCalculatedValue(parent, m!))

        calculatedPadding = CGFloat(p == nil ? 0 : UnitUtil.getCalculatedValue(parent, p!))
    }

    public func getPaddingLeft(_ parent: UIView) -> CGFloat {
        pl != nil ? UnitUtil.getCalculatedValue(parent, pl!) : calculatedPadding;
    }

    public func getPaddingRight(_ parent: UIView) -> CGFloat {
        pr != nil ? UnitUtil.getCalculatedValue(parent, pr!) : calculatedPadding;
    }

    public func getPaddingTop(_ parent: UIView) -> CGFloat {
        pt != nil ? UnitUtil.getCalculatedValue(parent, pt!) : calculatedPadding;
    }

    public func getPaddingBottom(_ parent: UIView) -> CGFloat {
        pb != nil ? UnitUtil.getCalculatedValue(parent, pb!) : calculatedPadding;
    }
}
