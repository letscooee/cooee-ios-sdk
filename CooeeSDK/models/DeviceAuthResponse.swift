//
//  DeviceAuthResponse.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation
import HandyJSON

/**
 DeviceAuthResponse Holds successful response from server if device get register

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct DeviceAuthResponse: Decodable, HandyJSON {

    var userID: String?
    var deviceID: String?
    var sdkToken: String?
}
