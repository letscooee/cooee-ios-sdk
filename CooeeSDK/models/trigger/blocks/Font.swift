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

    public func getFont(for partElement: PartElement) -> SwiftUI.Font {
        var font = SwiftUI.Font.system(size: getSize(), design: .default)


        if ff != nil {
            font = SwiftUI.Font.custom(ff!, size: getSize())
        }

        if tf != nil, let newFont = processTypeFace(for: partElement) {
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

    private func processTypeFace(for partElement: PartElement) -> SwiftUI.Font? {

        let font = checkForSystemFont()

        if font != nil {
            return font
        }

        let fontFile = getFontPath(of: tf!)

        if !FileManager.default.fileExists(atPath: fontFile.path) {
            return fontWithCustomStyle(partElement)
        }

        UIFont.register(from: fontFile)

        return SwiftUI.Font.custom(tf!, size: getSize())

    }

    private func checkForSystemFont() -> SwiftUI.Font? {
        for family in UIFont.familyNames {
            if family.caseInsensitiveCompare(tf!) == .orderedSame {
                return SwiftUI.Font.custom(family, size: getSize())
            }
        }
        return nil
    }

    private func fontWithCustomStyle(_ partElement: PartElement) -> SwiftUI.Font? {
        var typeFace = "\(tf!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))-"

        if partElement.isBold() {
            typeFace = "\(typeFace)bold"
        }

        if partElement.isItalic() {
            typeFace = "\(typeFace)italic"
        }

        let fontFile = getFontPath(of: typeFace)

        if !FileManager.default.fileExists(atPath: fontFile.path) {
            return nil
        }

        UIFont.register(from: fontFile)

        return SwiftUI.Font.custom(typeFace, size: getSize())
    }

    private func getFontPath(of name: String) -> URL {
        let fontDir = FontProcessor.getFontsStorageDirectory()
        return fontDir.appendingPathComponent("\(tf!).ttf")
    }
}
