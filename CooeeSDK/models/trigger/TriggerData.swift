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
    // MARK: Public

    public func getInAppTrigger() -> InAppTrigger? {
        ian
    }

    public mutating func setInAppTrigger(inAppTrigger: InAppTrigger) {
        self.ian = inAppTrigger
    }

    public func getPushNotification() -> PushNotificationTrigger? {
        pn
    }

    public func getAR() -> [String: Any]? {
        ar
    }

    // MARK: Internal

    var id: String?
    var v: Double?
    var engagementID: String?
    var `internal`: Bool? = false
    var expireAt: Int64?

    // MARK: Private

    private var ian: InAppTrigger?
    private var pn: PushNotificationTrigger?
    private var ar: [String: Any]?
}
