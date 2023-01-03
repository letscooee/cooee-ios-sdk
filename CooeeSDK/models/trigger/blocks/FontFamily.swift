//
// FontFamily.swift
// CooeeSDK
//
// Created by Ashish Gaikwad on 07/11/22.
//

import Foundation
import HandyJSON

/**
 Font-family which holds all fonts in the family

 - Author: Ashish Gaikwad
 - Since: 1.4.2
 */
struct FontFamily: HandyJSON, CustomStringConvertible {
    var fonts: [SDKFont]?
    var name: String?
    var description: String {
        "FontFamily(fonts: \(String(describing: fonts)), name: \(String(describing: name)))"
    }
}
