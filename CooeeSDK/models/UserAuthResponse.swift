//
//  UserAuthResponse.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct UserAuthResponse: Decodable {
    var id: String?
    // TODO: Uncomment deviceID once server is updated
    // var deviceID: String?
    var sdkToken: String?
}
