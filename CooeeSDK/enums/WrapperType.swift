//
// Created by Ashish Gaikwad on 31/05/22.
//

import Foundation
import HandyJSON

/**
 Type of wrapper

 - Author: Ashish Gaikwad
 - Since: 1.3.15
 */
@objc
public enum WrapperType: Int, HandyJSONEnum {
    case CORDOVA
    case REACT_NATIVE
    case FLUTTER

    func name() -> String {
        switch self {
            case .CORDOVA:
                return "CORDOVA"
            case .REACT_NATIVE:
                return "REACT_NATIVE"
            case .FLUTTER:
                return "FLUTTER"
        }
    }
}