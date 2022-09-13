//
//  Gradient.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Gradient: HandyJSON {
    // MARK: Public

    public enum `Type`: String, HandyJSONEnum {
        case LINEAR
        case RADIAL
        case SWEEP
    }

    /**
     Generates list of CGColor with provided colors

     - Returns: list of CGColor
     */
    public func getColors() -> [CGColor] {
        var list = [CGColor]()

        if let colour = c1 {
            list.append(UIColor(hexString: colour).cgColor)
        }

        if let colour = c2 {
            list.append(UIColor(hexString: colour).cgColor)
        }

        if let colour = c3 {
            list.append(UIColor(hexString: colour).cgColor)
        }

        if let colour = c4 {
            list.append(UIColor(hexString: colour).cgColor)
        }

        if let colour = c5 {
            list.append(UIColor(hexString: colour).cgColor)
        }

        return list
    }

    // MARK: Internal

    var type: Type?
    var c1: String?
    var c2: String?
    var c3: String?
    var c4: String?
    var c5: String?
    var ang: Int?
}
