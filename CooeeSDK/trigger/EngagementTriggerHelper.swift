//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import SwiftUI
import UIKit

/**
 A small helper class for any kind of engagement trigger like caching or retrieving from local storage.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
public class EngagementTriggerHelper {
    // MARK: Public

    public static func renderInAppTriggerFromJSONString(_ rawTriggerData: String) {
        let triggerData = TriggerData.deserialize(from: rawTriggerData)
        // TODO: 27/10/21: store active trigger details
        storeActiveTriggerDetails(triggerData: triggerData!)

        renderInAppTrigger(triggerData)
    }

    // MARK: Internal

    /**
     Store the current active trigger details in local storage for "late engagement tracking".

     - Parameter triggerData: Engagement trigger
     */
    static func storeActiveTriggerDetails(triggerData: TriggerData) {
        var activeTriggers: [EmbeddedTrigger] = LocalStorageHelper.getTypedArray(key: Constants.STORAGE_ACTIVATED_TRIGGERS,
                clazz: EmbeddedTrigger.self)
        let embeddedTrigger = EmbeddedTrigger(trigger: triggerData)
        activeTriggers.append(embeddedTrigger)
        LocalStorageHelper.putTypedArray(key: Constants.STORAGE_ACTIVATED_TRIGGERS, array: activeTriggers)
    }

    /**
     Get the list of non-expired active triggers from local storage for "late engagement tracking".

     - Returns: Array of <code>EmbeddedTrigger</code>
     */
    static func getActiveTriggers() -> [EmbeddedTrigger] {
        var activeTriggers: [EmbeddedTrigger] = LocalStorageHelper.getTypedArray(key: Constants.STORAGE_ACTIVATED_TRIGGERS,
                clazz: EmbeddedTrigger.self)
        var activeTriggersCurrent: [EmbeddedTrigger] = [EmbeddedTrigger]()

        for index in activeTriggers.startIndex..<activeTriggers.endIndex {

            if !activeTriggers[index].isExpired() {
                activeTriggersCurrent.append(activeTriggers[index])
            }

        }

        LocalStorageHelper.putTypedArray(key: Constants.STORAGE_ACTIVATED_TRIGGERS, array: activeTriggersCurrent)
        return activeTriggersCurrent
    }

    // MARK: Private

    /**
     Start rendering the in-app trigger.

     - Parameter data: received and parsed trigger data.
     */
    private static func renderInAppTrigger(_ data: TriggerData?) {
        if data == nil {
            return
        }
        let runtimeData = RuntimeData.shared

        if runtimeData.isInBackground() {
            return
        }

        do {
            if let visibleController = UIApplication.shared.topMostViewController() {
                setActiveTrigger(data!)
                try InAppTriggerScene.instance.updateViewWith(data: data!, on: visibleController)
            }
        } catch {
            CooeeFactory.shared.sentryHelper.capture(message: "Couldn't show Engagement Trigger", error: error as NSError)
        }
    }

    /**
     Set active trigger for the session

     - Parameter data: Instance of <code>TriggerData</code>
     */
    private static func setActiveTrigger(_ data: TriggerData) {
        let embeddedTrigger = EmbeddedTrigger(trigger: data)

        LocalStorageHelper.putTypedClass(key: Constants.STORAGE_ACTIVE_TRIGGER, data: embeddedTrigger)
    }
}
