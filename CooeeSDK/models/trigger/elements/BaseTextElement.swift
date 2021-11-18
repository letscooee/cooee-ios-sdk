//
//  BaseTextElement.swift
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

    // MARK: Internal

    var txt: String?
    var alg: Int?
    var f: Font?
    var c: Colour?
}
