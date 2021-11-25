//
//  ViewController.swift
//  Cooee iOS
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import BSON
import CooeeSDK
import HandyJSON
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let cooeeSDK = CooeeSDK.getInstance()
        cooeeSDK.setCurrentScreen(screenName: "Main")
        do {
            try cooeeSDK.sendEvent(eventName: "View Load", eventProperties: [String: Any]())
        } catch {}

        cooeeSDK.updateUserData(userData: ["name": "Ashish Gaikwad", "email": "ashish@iostest.com", "mobile": 9874563210])
    }

    @IBAction func loadPayload(_ sender: Any) {
        do {
            if let bundlePath = Bundle.main.url(forResource: "samplepayloadone",
                                                withExtension: "json")
            {
                print("path obtained")
                let jsonData = try Data(contentsOf: bundlePath)

                var json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
                json?.updateValue(ObjectId().hexString, forKey: "id")
                json?.updateValue(ObjectId().hexString, forKey: "engagementID")
                json?.updateValue((Date().timeIntervalSince1970*1000) + (5*60*1000), forKey: "expireAt")

                let rawString = String(data: json!.percentEncoded()!, encoding: .utf8)
                EngagementTriggerHelper.renderInAppTriggerFromJSONString(rawString!)
            } else {
                print("file not found")
            }
        } catch {
            print(error)
        }
    }
}

public extension Dictionary {
    func percentEncoded() -> Data? {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        return jsonData
    }
}
