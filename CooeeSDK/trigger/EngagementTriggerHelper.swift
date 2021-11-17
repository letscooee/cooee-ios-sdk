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
public class EngagementTriggerHelper {
    // MARK: Public

    public static func renderInAppTriggerFromJSONString(_ rawTriggerData: String) {
        let triggerData = TriggerData.deserialize(from: rawTriggerData)
        // TODO: 27/10/21: store active trigger details
        // storeActiveTriggerDetails(context, triggerData);

        renderInAppTrigger(triggerData)
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
                // try InAppTriggerScene.instance.updateViewWith(data: data!, on: visibleController)
                let host = UIHostingController(rootView: DemoInAppOne(data: data!))
                guard let hostView = host.view else {
                    print("fail to load swiftUI")
                    return
                }
                hostView.translatesAutoresizingMaskIntoConstraints = false
                visibleController.view.addSubview(hostView)
                // hostView.centerMe
            }
        } catch {
            CooeeFactory.shared.sentryHelper.capture(message: "Couldn't show Engagement Trigger", error: error as NSError)
        }
    }
}
