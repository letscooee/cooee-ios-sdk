//
//  Event.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/09/21.
//

import Foundation

struct Event {
    // MARK: Lifecycle

    init(eventName: String) {
        self.init(eventName: eventName, properties: [String: Any?]())
    }

    init(eventName: String, triggerData: TriggerData) {
        self.init(eventName: eventName)
    }

    init(eventName: String, properties: [String: Any?]) {
        name=eventName
        self.properties=properties
        occurred=DateUtils.formatDateToUTCString(date: Date())
    }

    // MARK: Internal

    var name: String?
    var properties: [String: Any?]?
    var sessionID: String?
    var sessionNumber: Int?
    var screenName: String?
    var activeTriggers: [[String: Any]]?
    var occurred: String?
    var deviceProps: [String: Any]?

    mutating func withTrigger(triggerData: TriggerData) {
        properties?.updateValue(triggerData.triggerID, forKey: "triggerID")
    }

    func toDictionary() -> [String: Any?] {
        var dictionary=[String: Any?]()

        dictionary["name"]=name
        dictionary["properties"]=properties
        dictionary["sessionID"]=sessionID
        dictionary["sessionNumber"]=sessionNumber
        dictionary["screenName"]=screenName
        dictionary["activeTriggers"]=activeTriggers
        dictionary["occurred"]=occurred
        dictionary["deviceProps"]=deviceProps

        return dictionary
    }
}
