//
//  AppAR.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct AppAR: Codable {

    let name: String
    let splash: [String: AnyValue]?
    let data: [String: AnyValue]?
}
