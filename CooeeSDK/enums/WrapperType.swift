//
// Created by Ashish Gaikwad on 21/06/22.
//

import Foundation

/**
 Type of wrapper

 - Author: Ashish Gaikwad
 - Since: 1.3.16
 */
@objc
public enum WrapperType: Int, RawRepresentable {
    case CORDOVA
    case REACT_NATIVE
    case FLUTTER

    // MARK: Lifecycle

    public init?(rawValue: RawValue) {
        switch rawValue {
            case "CORDOVA":
                self = .CORDOVA
            case "REACT_NATIVE":
                self = .REACT_NATIVE
            case "FLUTTER":
                self = .FLUTTER
            default:
                return nil
        }
    }

    // MARK: Public

    public typealias RawValue = String

    public var rawValue: RawValue {
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