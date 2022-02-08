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


    // MARK: Public

    /**
     Provides ``SwiftUI.Alignment`` to apply with frame of ``SwiftUI.View``

     - Returns: ``SwiftUI.Alignment``
     */
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

    /**
     Provides ``SwiftUI.TextAlignment`` to apply alignment on ``SwiftUI.Text``

     - Returns: ``SwiftUI.TextAlignment``
     */
    public func getTextAlignment() -> SwiftUI.TextAlignment {
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

    /**
     Process ``c`` and generates ``SwiftUI.Color``
     - Returns: Optional instance of ``SwiftUI.Color``
     */
    public func getColour() -> Color? {
        return c == nil ? nil : Color(hex: c!.getColour(), alpha: c!.getAlpha())
    }

    /**
     Process ``f`` and generates ``SwiftUI.Font``, In case ``f`` is nil
     process font from ``PartElement``
     - Parameter part:
     - Returns:
     */
    public func getFont(for part: PartElement) -> SwiftUI.Font {
        if f == nil {
            return SwiftUI.Font.system(size: 14)
        } else {
            return f!.getFont(for: part)
        }
    }

    // MARK: Internal

    private var txt: String?
    private var alg: Int?
    private var f: Font?
    private var c: Colour?
}
