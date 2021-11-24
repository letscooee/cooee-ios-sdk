//
//  EmbeddedTrigger.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 24/11/21.
//

import Foundation
import HandyJSON

class EmbeddedTrigger: Codable, HandyJSON {
    // MARK: Lifecycle

    required init() {}

    init(triggerID: String, engagementID: String, expireAt: Int64) {
        self.triggerID = triggerID
        self.engagementID = engagementID
        self.expireAt = expireAt
    }

    init(trigger: TriggerData) {
        self.triggerID = trigger.id!
        self.engagementID = trigger.engagementID!
        self.expireAt = trigger.expireAt!
    }

    // MARK: Public

    public func getExpireAt() -> Int64 {
        return expireAt!
    }

    public func isExpired() -> Bool {
        return getExpireAt() < Int64(Date().timeIntervalSince1970 * 1000)
    }

    // MARK: Private

    private var triggerID: String?
    private var engagementID: String?
    private var expireAt: Int64?
}
