//
//  AppAR.swift
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
struct AppAR: HandyJSON {
    
    var name: String?
    var splash: [String: Any]?
    var data: [String: Any]?
}
