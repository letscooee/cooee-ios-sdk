//
//  TriggerData.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/09/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct TriggerData: HandyJSON {

    var id: String?
    var v: Double?
    var engagementID: String?
    var `internal`: Bool? = false
    var expireAt: Int64?
    private var ian: InAppTrigger?

    public func getInAppTrigger() -> InAppTrigger? {
        ian
    }
}
