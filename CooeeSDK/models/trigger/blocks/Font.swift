//
//  Font.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 19/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Font: HandyJSON {
    private static let DEFAULT_SIZE: CGFloat = UIFont.systemFontSize
    var size: Float?
    var style: String?
    var name: String?
    var lineHeight: String?

    public func getSize() -> CGFloat {
        print("\(size == nil ? Font.DEFAULT_SIZE : UnitUtil.getScaledPixel(size!))")
        return size == nil ? Font.DEFAULT_SIZE : UnitUtil.getScaledPixel(size!)
    }
}
