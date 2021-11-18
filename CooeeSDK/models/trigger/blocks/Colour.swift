//
//  Colour.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON
import UIKit

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Colour: HandyJSON {

    var h: String?
    var a: Int?
    var g: Gradient?

    func getColour() -> UIColor {
        UIColor(hexString: h!)
    }

    func getColour() -> String {
        print("colour: \(h ?? "#000000")")
        return h ?? "#000000"
    }
}
