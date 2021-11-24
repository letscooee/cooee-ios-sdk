//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import SwiftUI
import UIKit

/**
 A small helper class for any kind of engagement trigger like caching or retriving from local storage.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
public enum EngagementTriggerHelper {
    // MARK: Public

    public static func renderInAppTriggerFromJSONString(_ rawTriggerData: String) {
        let triggerData = TriggerData.deserialize(from: rawTriggerData)
        // TODO: 27/10/21: store active trigger details
        // storeActiveTriggerDetails(context, triggerData);

        renderInAppTrigger(triggerData)
    }

    // MARK: Internal

    static func storeActiveTriggerDetails(triggerData: TriggerData) {
        var activeTriggers: [EmbeddedTrigger] = LocalStorageHelper.getTypedArray(key: Constants.STORAGE_ACTIVATED_TRIGGERS, clazz: EmbeddedTrigger.self)
        let embeddedTrigger = EmbeddedTrigger(trigger: triggerData)
        activeTriggers.append(embeddedTrigger)
        LocalStorageHelper.putArray(key: Constants.STORAGE_ACTIVATED_TRIGGERS, array: activeTriggers)
    }

    static func getActiveTriggers() -> [EmbeddedTrigger] {
        var activeTriggers: [EmbeddedTrigger] = LocalStorageHelper.getTypedArray(key: Constants.STORAGE_ACTIVATED_TRIGGERS, clazz: EmbeddedTrigger.self)
        
        for index in activeTriggers.startIndex ..< activeTriggers.endIndex {
            
            if activeTriggers[index].isExpired() {
                activeTriggers.remove(at: index)
            }
            
        }
        
        LocalStorageHelper.putArray(key: Constants.STORAGE_ACTIVATED_TRIGGERS, array: activeTriggers)
        return activeTriggers
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
                try InAppTriggerScene.instance.updateViewWith(data: data!, on: visibleController)
                setActiveTrigger(data!)
            }
        } catch {
            CooeeFactory.shared.sentryHelper.capture(message: "Couldn't show Engagement Trigger", error: error as NSError)
        }
    }
    
    private static func setActiveTrigger(_ data: TriggerData){
        let embededTrigger = EmbeddedTrigger(trigger: data)
        
        LocalStorageHelper.putAnyClass(key: Constants.STORAGE_ACTIVE_TRIGGER, data: embededTrigger)
    }
}
