//
//  Alignment.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 19/10/21.
//

import Foundation
import HandyJSON
import UIKit

/**
 Alignment is class which provide text properties like text alignment or text direction

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct Alignment: HandyJSON {
    // MARK: Public

    public enum Direction: String, HandyJSONEnum {
        case LTR
        case RTL
    }

    // MARK: Internal

    var align: TextAlignment? = TextAlignment.CENTER
    var direction: Direction? = Direction.LTR

    public func getAlignment() -> NSTextAlignment {
        switch align {

            case .CENTER:
                return .center
            case .LEFT:
                return .left
            case .RIGHT:
                return .right
            case .none:
                return .center
        }
    }

    public func getButtonAlignment() -> UIControl.ContentHorizontalAlignment {
        switch align {

            case .CENTER:
                return .center
            case .LEFT:
                return .left
            case .RIGHT:
                return .right
            case .none:
                return .center
        }
    }
}
