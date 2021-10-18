//
//  TriggerData.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/09/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct TriggerData: Codable {

    var id: String
    var version: Double
    var engagementID: String
    var `internal`: Bool = false
    var expireAt: Int64
}
