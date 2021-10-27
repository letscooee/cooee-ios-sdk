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
    var size: String?
    var style: String?
    var name: String?
    var lineHeight: String?

    public func getSize() -> CGFloat {
        size == nil ? Font.DEFAULT_SIZE : UnitUtil.getCalculatedPixel(size!)
    }
}
