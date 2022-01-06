//
//  PartElement.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 24/11/21.
//

import Foundation
import SwiftUI

/**
 Part holds text, and its particular properties like Bold, Italic, Underline, Strikethrough and colour

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class PartElement: BaseElement, Identifiable {
    // MARK: Public

    public func isBold() -> Bool {
        b ?? false
    }

    public func isItalic() -> Bool {
        i ?? false
    }

    public func addUnderLine() -> Bool {
        u ?? false
    }

    public func addStrikeThrough() -> Bool {
        st ?? false
    }

    public func getPartColour() -> Color? {
        return c == nil ? nil : Color(hex: c!)
    }

    public func getPartText() -> String {
        return txt ?? ""
    }
    
    public func setPartText(_ text: String){
        txt=text
    }

    // MARK: Private

    private var txt: String?
    private var b: Bool?
    private var i: Bool?
    private var u: Bool?
    private var c: String?
    private var st: Bool?
}
