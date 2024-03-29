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
class PendingTriggerService {
    // MARK: Lifecycle

    init() {
        pendingTriggerDAO = PendingTriggerDAO()
    }

    // MARK: Internal

    var pendingTriggerDAO: PendingTriggerDAO

    /**
     Inserts the given trigger into the Database and load triggers content to store it.

     - Parameters:
       - triggerData: The trigger data to be inserted.
       - notificationID: The notification ID of the trigger.
     */
    func lazyLoadAndSave(_ triggerData: TriggerData, forNotification notificationID: String) {

        if !shouldFetchInApp(triggerData) {
            return
        }

        let pendingTriggerModel = PendingTriggerModel(triggerData: triggerData, notificationId: notificationID)
        let pendingTrigger = pendingTriggerDAO.insert(pendingTriggerModel)
        NSLog("\(Constants.TAG) Created PendingTrigger(id=\(pendingTrigger.id))")

        LazyTriggerLoader.load(for: triggerData) { rawTriggerData in
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
            NSLog("\(Constants.TAG) Updated PendingTrigger(id=\(pendingTrigger.id))")
        }
    }

    /**
    Checks if feature is present or not.

    - Parameter data: {@link TriggerData} object to be checked.
    - Returns: true if InApp/AR is present, false otherwise.
    <ul>
    <li>If its null, will allow to load InApp from server</li>
    <li>If its empty, will allow to load InApp from server</li>
    <li>If its present, Will loop and check if there is any feature except PN is present or not.</li>
    <ol>
    <li>If present, Will allow loading data from server</li>
    </ol>
    </ul>
     */
    private func shouldFetchInApp(_ data: TriggerData) -> Bool {
        if (data.getFeatures()?.isEmpty ?? true) {
            return true;
        }

        for feature in data.getFeatures() ?? [Int]() {
            if (feature == 2 || feature == 3) {
                return true;
            }
        }

        return false;
    }

    /**
     Provides latest pending trigger from stack

     - Returns: Latest pending trigger from stack
     */
    func peep() -> PendingTrigger? {
        guard let pendingTrigger = pendingTriggerDAO.getFirst() else {
            return nil
        }

        return pendingTrigger
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
    func getTriggerByTriggerId(_ triggerId: String) -> PendingTrigger? {
        pendingTriggerDAO.fetchTriggerWithTriggerId(triggerId)
    }

    /**
     Delete the provided pending trigger from database.

     - Parameter trigger: The pending trigger to be deleted.
     */
    func removeTrigger(_ trigger: PendingTrigger) {
        pendingTriggerDAO.delete(trigger)
    }
}
