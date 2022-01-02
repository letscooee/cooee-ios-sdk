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
 Font is class which holds the font properties like font size, line height, font family,

 - Author: Ashish Gaikwad
 - Since: 1.3.0
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
        
        if tf != nil, let newFont = processTypeFace(){
            font = newFont
        }

        return font
    }

    // MARK: Internal

    private var s: Float?
    private var ff: String?
    private var tf: String?
    private var lh: Float?

    // MARK: Private

    private static let DEFAULT_SIZE: CGFloat = UIFont.systemFontSize
    
    private func processTypeFace() -> SwiftUI.Font? {
        
        let fontDir = FontProcessor.getFontsStorageDirectory()
        let fontFile = fontDir.appendingPathComponent("\(tf!).ttf")
        
        if !FileManager.default.fileExists(atPath: fontFile.path) {
            return nil
        }
        
        UIFont.register(from: fontFile)
        
        return SwiftUI.Font.custom(tf!, size: getSize())
        
    }
}
