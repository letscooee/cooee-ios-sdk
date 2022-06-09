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
    // MARK: Lifecycle

    init() {
        pendingTriggerDAO = PendingTriggerDAO()
    }

    // MARK: Internal

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

            storedTriggerData.merge(responseMap) { _, new in
                new
            }
            pendingTrigger.triggerData = storedTriggerData.toJSONString()
            pendingTrigger.loadedLazyData = true
            self.pendingTriggerDAO.update(pendingTrigger)
            NSLog("Updated PendingTrigger(id=\(pendingTrigger.id))")
        }
    }

    /**
     Provides latest pending trigger from stack

     - Returns: Latest pending trigger from stack
     */
    func getLatestTrigger() -> PendingTrigger? {
        let pendingTriggerList = pendingTriggerDAO.fetchTriggers()

        if pendingTriggerList.isEmpty {
            return nil
        }

        return pendingTriggerList.first
    }

    /**
     Removes the given trigger from the Database.

     - Parameter triggerId: The trigger ID to be removed.
     */
    func removeTrigger(_ triggerId: String) {
        pendingTriggerDAO.deleteTriggerByTriggerId(triggerId)
    }

    /**
     Fetch pending trigger with given trigger ID.

     - Parameter triggerId: The trigger ID to be searched.
     - Returns: The pending trigger with given trigger ID.
     */
    func getTriggerBy(_ triggerId: String) -> PendingTrigger? {
        pendingTriggerDAO.fetchTriggerWithTriggerId(triggerId)
    }

    /**
     Delete the provided pending trigger from database.

     - Parameter trigger: The pending trigger to be deleted.
     */
    func removeTrigger(_ trigger: PendingTrigger) {
        pendingTriggerDAO.delete(trigger)
    }

    // MARK: Private

    private let pendingTriggerDAO: PendingTriggerDAO
}
