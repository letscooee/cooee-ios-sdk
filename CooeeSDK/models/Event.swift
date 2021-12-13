//
//  Event.swift
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
struct Event: HandyJSON {
    // MARK: Lifecycle

    init() {}

    init(eventName: String) {
        self.init(eventName: eventName, properties: [String: Any?]())
    }

    init(eventName: String, triggerData: TriggerData) {
        self.init(eventName: eventName)
    }

    init(eventName: String, properties: [String: Any?]) {
        name = eventName
        self.properties = properties
        occurred = DateUtils.formatDateToUTCString(date: Date())
    }

    init(from decoder: Decoder) throws {}

    // MARK: Internal

    var name: String?
    var properties: [String: Any?]?
    var sessionID: String?
    var sessionNumber: Int?
    var screenName: String?
    var activeTriggers: [EmbeddedTrigger]?
    var activeTrigger: EmbeddedTrigger?
    var occurred: String?
    var deviceProps: [String: Any]?

    mutating func withTrigger(triggerData: TriggerData) {
        properties?.updateValue(triggerData.id, forKey: "triggerID")
    }

    func toDictionary() -> [String: Any?] {
        ["name": name,
         "properties": properties,
         "sessionID": sessionID,
         "sessionNumber": sessionNumber,
         "screenName": screenName,
         "activeTriggers": activeTriggers,
         "trigger": activeTrigger,
         "occurred": occurred,
         "deviceProps": deviceProps] as [String: Any?]
    }

    func encode(to encoder: Encoder) throws {}
}
