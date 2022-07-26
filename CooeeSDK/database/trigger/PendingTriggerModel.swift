//
//  PendingTriggerModel.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 08/06/22.
//

import Foundation

/**
 Helper class which will hold PendingTrigger details

 - Author: Ashish Gaikwad
 - Since: 1.3.16
 */
class PendingTriggerModel {
    // MARK: Lifecycle

    init(triggerId: String, notificationId: String, triggerTime: Date, scheduleAt: Date, triggerData: String, sdkCode: Int, loadedLazyData: Bool) {
        self.triggerId = triggerId
        self.notificationId = notificationId
        self.triggerTime = triggerTime
        self.scheduleAt = scheduleAt
        self.triggerData = triggerData
        self.sdkCode = sdkCode
        self.loadedLazyData = loadedLazyData
    }

    init(triggerData: TriggerData, notificationId: String? = nil) {
        triggerId = triggerData.id ?? ""
        self.notificationId = notificationId ?? ""
        triggerTime = Date()
        scheduleAt = Date()
        self.triggerData = triggerData.toJSONString() ?? ""
        sdkCode = SDKInfo.shared.cachedInfo.sdkVersionCode
        loadedLazyData = false
    }

    // MARK: Internal

    var triggerId: String
    var notificationId: String
    var triggerTime: Date
    var scheduleAt: Date
    var triggerData: String
    var sdkCode: Int
    var loadedLazyData: Bool
}
