//
// SDKFont.swift
// CooeeSDK
//
// Created by Ashish Gaikwad on 07/11/22.
//

import Foundation
import HandyJSON

/**
 Class that holds font url with its `FontStyle`

 - Author: Ashish Gaikwad
 - Since: 1.4.2
 */
struct SDKFont: HandyJSON, CustomStringConvertible {
    var style: FontStyle?
    var url: String?
    var description: String {
        "SDKFont(style: \(String(describing: style)), url: \(String(describing: url)))"
    }
}
