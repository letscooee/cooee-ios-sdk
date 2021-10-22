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

    var hex: String?
    var grad: Gradient?

    func getColour() -> UIColor {
        UIColor(hexString: hex!)
    }
}
