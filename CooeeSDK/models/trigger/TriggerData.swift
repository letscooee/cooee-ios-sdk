//
//  TriggerData.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/09/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct TriggerData: HandyJSON {
    // MARK: Public

    public static func fromHSON(from jsonString: String) -> TriggerData {
        TriggerData.deserialize(from: jsonString) ?? TriggerData()
    }

    public func getInAppTrigger() -> InAppTrigger? {
        ian
    }

    public mutating func setInAppTrigger(inAppTrigger: InAppTrigger?) {
        ian = inAppTrigger
    }

    public func getPushNotification() -> PushNotificationTrigger? {
        pn
    }

    public func getAR() -> [String: Any]? {
        ar
    }

    public func getFeatures() -> [Int]? {
        features
    }

    public func getConfig() -> [String: Any]? {
        config
    }

    public func isContainValidData() -> Bool {
        return !(id?.isEmpty ?? true) && ian != nil && ian!.isContainValidData()
    }

    // MARK: Internal

    var id: String?
    var v: Double?
    var engagementID: String?
    var `internal`: Bool? = false
    var expireAt: Int64?

    // MARK: Private

    private var ian: InAppTrigger?
    private var pn: PushNotificationTrigger?
    private var ar: [String: Any]?
    private var features: [Int]?
    private var config: [String: Any]?

    func toString() -> String {
        "Trigger{id='\(String(describing: id))'}"
    }
}
