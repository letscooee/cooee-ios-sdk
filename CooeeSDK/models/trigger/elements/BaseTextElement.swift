//
//  BaseTextElement.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 19/10/21.
//

import Foundation
import HandyJSON
import SwiftUI

/**
 BaseTextElement holds the text Alignment, Font and Colour

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class BaseTextElement: BaseElement {
    // MARK: Lifecycle

    required init() {
    }

    // MARK: Public

    public func getAlignment() -> NSTextAlignment {
        switch alg {
            case 0:
                return .center
            case 1:
                return .left
            case 2:
                return .right
            case .none:
                return .center
            case .some:
                return .center
        }
    }

    public func getButtonAlignment() -> UIControl.ContentHorizontalAlignment {
        switch alg {
            case 0:
                return .center
            case 1:
                return .left
            case 2:
                return .right
            case .none:
                return .center
            case .some:
                return .center
        }
    }

    public func getSwiftUIHorizontalAlignment() -> SwiftUI.HorizontalAlignment {
        switch alg {
            case 0:
                return .leading
            case 1:
                return .center
            case 2:
                return .trailing
            case .none:
                return .leading
            case .some:
                return .leading
        }
    }
    
    public func getSwiftUIAlignment() -> SwiftUI.Alignment {
        switch alg {
            case 0:
                return .leading
            case 1:
                return .center
            case 2:
                return .trailing
            case .none:
                return .leading
            case .some:
                return .leading
        }
    }

    public func getColour() -> Color? {
        return c == nil ? nil : Color(hex: c!.getColour(), alpha: c!.getAlpha())
    }

    public func getFont() -> SwiftUI.Font {
        if f == nil {
            return SwiftUI.Font.system(size: 14)
        } else {
            return f!.getFont()
        }
    }

    // MARK: Internal

    private var txt: String?
    private var alg: Int?
    private var f: Font?
    private var c: Colour?
}
