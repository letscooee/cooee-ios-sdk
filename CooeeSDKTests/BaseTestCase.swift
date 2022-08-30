//
//  BaseTestCase.swift
//  CooeeSDKTests
//
//  Created by Ashish Gaikwad on 04/04/22.
//

@testable import CooeeSDK
import Foundation
import XCTest

class BaseTestCase: XCTestCase {
    var samplePayload: String!
    var samplePayloadMap: [String: Any]!
    var invalidDataMap: [String: Any]!
    var triggerData: TriggerData!
    var expiredTriggerData: TriggerData!

    override func setUpWithError() throws {
        do {
            if let bundlePath = Bundle(for: type(of: self)).url(forResource: "payload", withExtension: "json") {
                print("path obtained")
                let jsonData = try Data(contentsOf: bundlePath)

                samplePayloadMap = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
                samplePayloadMap?.updateValue(ObjectID().hexString, forKey: "engagementID")
                expiredTriggerData = TriggerData.deserialize(from: samplePayloadMap)
                
                samplePayloadMap?.updateValue((Date().timeIntervalSince1970 * 1000) + (5 * 1000), forKey: "expireAt")

                samplePayload = String(data: samplePayloadMap!.percentEncoded()!, encoding: .utf8)
                triggerData = TriggerData.deserialize(from: samplePayload)

            } else {
                print("file not found")
            }
            
            if let bundlePath = Bundle(for: type(of: self)).url(forResource: "invalid_data", withExtension: "json") {
                print("path obtained")
                let jsonData = try Data(contentsOf: bundlePath)

                invalidDataMap = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]

            } else {
                print("invalid data file not found")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }

    override func tearDownWithError() throws {
        samplePayload = nil
        samplePayloadMap = nil
        triggerData = nil
    }
}
