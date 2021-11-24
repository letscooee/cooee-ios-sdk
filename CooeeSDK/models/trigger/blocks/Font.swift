//
//  Font.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 19/10/21.
//

import Foundation
import HandyJSON
import SwiftUI

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Font: HandyJSON {
    // MARK: Public

    public func getSize() -> CGFloat {
        return s == nil ? Font.DEFAULT_SIZE : UnitUtil.getScaledPixel(s!)
    }

    public func getLineHeight() -> CGFloat? {
        return lh == nil ? nil : UnitUtil.getScaledPixel(s!)
    }

    public func getFont() -> SwiftUI.Font {
        var font = SwiftUI.Font.system(size: getSize(), design: .default)

        if ff != nil {
            font = SwiftUI.Font.custom(ff!, size: getSize())
        }

        return font
    }

    // MARK: Internal

    var s: Float?
    var ff: String?
    var tf: String?
    var lh: Float?

    // MARK: Private

    private static let DEFAULT_SIZE: CGFloat = UIFont.systemFontSize
}
