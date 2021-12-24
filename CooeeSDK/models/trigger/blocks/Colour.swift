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
 Colour os class which holds colour variants for element
 It can be solid background or it may have alpha in it
 or it may have gradient.
 It can have recolour with alpha or gradient at a time

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct Colour: HandyJSON {

    private var h: String?
    private var a: Int?
    var g: Gradient?

    func getColour() -> UIColor {
        UIColor(hexString: h!)
    }

    func getColour() -> String {
        return h ?? "#000000"
    }

    func getAlpha() -> Double {
        Double(a ?? 100)
    }
}
