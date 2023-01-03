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

        guard let fontFamily = fmly else {
            return SwiftUI.Font.custom("Arial", size: getSize())
        }

        return SwiftUI.Font.custom(fontFamily.name ?? "Arial", size: getSize())
    }

    /**
     Collect all string URLs from font-family
     - Returns: Optional list optional string URL
     */
    public func getFontURLs() -> [String?]? {
        guard let fontFamily = fmly else {
            return nil
        }

        guard let sdkFonts = fontFamily.fonts, !sdkFonts.isEmpty else {
            return nil
        }

        var urls: [String?] = []
        for sdkFont in sdkFonts {
            urls.append(sdkFont.url)
        }

        return urls
    }

    // MARK: Internal

    private var s: Float?
    private var fmly: FontFamily?
    private var tf: String?
    private var lh: Float?

    // MARK: Private

    private static let DEFAULT_SIZE: CGFloat = UIFont.systemFontSize

    /**
     Process ``ft`` and get font from storage
     - Parameter partElement: Instance of <code>PartElement</code> whose style need to be updated
     - Returns: Instance of <code>PartElement</code> whose style need to be updated
     */
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

    /**
     Access and check ``tf`` in ``UIFont.familyNames`` list

     - Returns: Optional ``SwiftUI.Font`` if font is available, Otherwise ``null``
     */
    private func checkForSystemFont() -> SwiftUI.Font? {
        for family in UIFont.familyNames {
            if family.caseInsensitiveCompare(tf!) == .orderedSame {
                return SwiftUI.Font.custom(family, size: getSize())
            }
        }

        return nil
    }

    /**
     Generates font name with the help of part style and search related file in storage
            Lowercase & trim ``Font.ft`` e.g. poppins<br/>
            |
            |- Check if part is Bold and add 'bold' in font name eg. poppins-bold
            |
            |- Check if part is Italic and add 'italic' in font name eg. poppins-italic, poppins-bolditalic

     - Parameter partElement: Instance of <code>PartElement</code> whose style need to be updated
     - Returns: Optional ``SwiftUI.Font`` if file is present, Otherwise ``null``
     */
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

    /**
     Generates ``URL`` from file name

     - Parameter name: Name of the file for which path need to be create
     - Returns: ``URL`` of the given file
     */
    private func getFontPath(of name: String) -> URL {
        let fontDir = FontProcessor.getFontsStorageDirectory()
        return fontDir.appendingPathComponent("\(tf!).ttf")
    }
}
