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

    init() {
    }

    init(eventName: String) {
        self.init(eventName: eventName, properties: [String: Any?]())
    }

    init(eventName: String, triggerData: TriggerData) {
        self.init(eventName: eventName)
        self.withTrigger(triggerData: triggerData)
    }

    init(eventName: String, properties: [String: Any?]) {
        self.name = eventName
        self.properties = properties
        self.occurred = DateUtils.formatDateToUTCString(date: Date())
    }

    init(eventName: String, deviceProps: [String: Any?]) {
        self.init(eventName: eventName)
        self.deviceProps = deviceProps as [String: Any]
    }

    init(from decoder: Decoder) throws {
    }

    // MARK: Internal

    var name: String?
    var properties: [String: Any?]?
    var sessionID: String?
    var sessionNumber: Int?
    var screenName: String?
    var activeTriggers: [EmbeddedTrigger]?
    var trigger: EmbeddedTrigger?
    var occurred: String?
    var deviceProps: [String: Any]?

    mutating func withTrigger(triggerData: TriggerData) {
        properties?.updateValue(triggerData.id ?? "", forKey: "triggerID")
    }

    func toDictionary() -> [String: Any?] {
        ["name": name,
         "properties": properties,
         "sessionID": sessionID,
         "sessionNumber": sessionNumber,
         "screenName": screenName,
         "activeTriggers": activeTriggers,
         "trigger": trigger,
         "occurred": occurred,
         "deviceProps": deviceProps] as [String: Any?]
    }

    func encode(to encoder: Encoder) throws {
    }
}
