//
//  Event.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/09/21.
//

import Foundation

struct Event: Decodable {
    // MARK: Lifecycle

    init(eventName: String) {
        self.init(eventName: eventName, properties: {})
    }

    init(eventName: String, triggerData: TriggerData) {
        self.init(eventName: eventName)
    }

    init(eventName: String, properties: [String, Any]) {
        name = eventName
        self.properties = properties
        occurred = Date()
    }

    // MARK: Internal

    var name: String?
    var properties: [String, Any]?
    var sessionID: String?
    var sessionNumber: Int?
    var screenName: String?
    var activeTriggers: [[String, Object]]?
    var occurred: Date?
    var deviceProps = [String, Any]?

    func withTrigger(triggerData: TriggerData) {
        properties["triggerID"] = triggerData.triggerID
    }
}
