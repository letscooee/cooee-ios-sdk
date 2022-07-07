//
//  BrowserContent.swift
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
struct BrowserContent: HandyJSON {

    var u: String? // http URL
    var showAB: Bool? = false
    var qp: [String: Any]? // query parameters
}
