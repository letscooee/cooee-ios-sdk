//
//  CacheTriggerContent.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 08/06/22.
//

import Foundation

/**
 Helper class which allows multiple operation on Pending trigger.

 - Author: Ashish Gaikwad
 - Since: 1.3.16
 */
class CacheTriggerContent {
    private let pendingTriggerDAO: PendingTriggerDAO

    init() {
        pendingTriggerDAO = PendingTriggerDAO()
    }

    /**
    Inserts the given trigger into the Database and load triggers content to store it.

     - Parameters:
       - triggerData: The trigger data to be inserted.
       - notificationID: The notification ID of the trigger.
     */
    func loadAndSaveTriggerData(_ triggerData: TriggerData, forNotification notificationID: String) {
        let pendingTriggerModel = PendingTriggerModel(triggerData: triggerData, notificationId: notificationID)
        let pendingTrigger = pendingTriggerDAO.insert(pendingTriggerModel)
        NSLog("Created PendingTrigger(id=\(pendingTrigger.id))")
        InAppTriggerHelper.loadLazyData(for: triggerData) { rawTriggerData in
            if rawTriggerData.isEmpty {
                return
            }

            guard let responseMap = rawTriggerData.convertToDictionary(), !responseMap.isEmpty else {
                return
            }

            guard var storedTriggerData = pendingTrigger.triggerData?.convertToDictionary() else {
                return
            }

            storedTriggerData.merge(responseMap) { (_, new) in
                new
            }
            pendingTrigger.triggerData = storedTriggerData.toJSONString()
            pendingTrigger.loadedLazyData = true
            self.pendingTriggerDAO.update(pendingTrigger)
            NSLog("Updated PendingTrigger(id=\(pendingTrigger.id))")
        }
    }
}
