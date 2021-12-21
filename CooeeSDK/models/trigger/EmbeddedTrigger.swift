//
//  EmbeddedTrigger.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 24/11/21.
//

import Foundation
import HandyJSON

/**
 This class store data related to triggers which are active/activated by clicking on the trigger notification or by
 looking an in-app trigger(in future). This would be commonly sent with events {@link com.letscooee.models.Event}
 as <code>activeTrigger</code>.
 
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class EmbeddedTrigger: Codable, HandyJSON {
    // MARK: Lifecycle

    required init() {
    }

    init(triggerID: String, engagementID: String, expireAt: Int64) {
        self.triggerID = triggerID
        self.engagementID = engagementID
        self.expireAt = expireAt
        self.expired = isExpired()
    }

    init(trigger: TriggerData) {
        self.triggerID = trigger.id
        self.engagementID = trigger.engagementID
        self.expireAt = trigger.expireAt
        self.expired = isExpired()
    }

    // MARK: Public

    public func getExpireAt() -> Int64 {
        return expireAt ?? Int64(Date().timeIntervalSince1970 * 1000)
    }

    public func isExpired() -> Bool {
        return getExpireAt() < Int64(Date().timeIntervalSince1970 * 1000)
    }

    // MARK: Private

    private var triggerID: String?
    private var engagementID: String?
    private var expireAt: Int64?
    private var expired: Bool?
}
