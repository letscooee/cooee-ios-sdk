//
//  InAppTriggerHelper.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 02/12/21.
//

import Foundation

/**
 A small helper class for in-app trigger for fetching data from server.

 - Author: Ashish Gaikwad
 - Since: 1.0.0
 */
class InAppTriggerHelper {
    // MARK: Internal

    /**
     Load in-app data on a separate thread through a http call to server.

     - Parameters:
       - triggerData: engagement trigger {@link TriggerData}
       - callback: callback on complete
     */
    static func loadLazyData(for triggerData: TriggerData, callback: @escaping (_ result: String) -> ()) {
        let thread = DispatchQueue.global()

        thread.async {
            let rawTriggerData = String(decoding: doHTTPForIAN(id: triggerData.id!)?.percentEncoded() ?? Data(), as: UTF8.self)

            DispatchQueue.main.async {
                callback(rawTriggerData)
            }
        }
    }

    // MARK: Private

    /**
     Convert raw in-app data received from {@link #doHTTPForIAN} to InAppTrigger instance.

     - Parameter data: raw in-app data
     - Returns: InAppTrigger instance
     */
    private static func getIANFromRawIAN(from data: [String: Any]?) -> InAppTrigger? {
        if data == nil {
            return nil
        }

        return (TriggerData.deserialize(from: data!))?.getInAppTrigger()
    }

    /**
     Perform HTTP call to get IAN(In-App Notification Data) from server.

     - Parameter triggerId: trigger id received from FCM
     - Returns: response data from server
     */
    private static func doHTTPForIAN(id triggerId: String) -> [String: Any]? {
        do {
            return try CooeeFactory.shared.baseHttpService.loadTriggerDetails(id: triggerId)
        } catch {
            CooeeFactory.shared.sentryHelper.capture(error: error as NSError)
        }
        return nil
    }
}
