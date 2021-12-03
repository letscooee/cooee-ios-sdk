//
//  DeviceAuthResponse.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct DeviceAuthResponse: Decodable, HandyJSON {
    var id: String?
    var deviceID: String?
    var sdkToken: String?
}
