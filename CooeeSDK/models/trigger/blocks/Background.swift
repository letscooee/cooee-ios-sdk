//
//  Background.swift
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
struct Background: HandyJSON {
    
    var solid: Colour?
    var glossy: Glossy?
    var image: Image?
}
