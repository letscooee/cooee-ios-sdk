//
//  ViewController.swift
//  Cooee iOS
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import CooeeSDK
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
                                                    withExtension: "json"){
                    print("path obtained")
                    let jsonData = try Data(contentsOf: bundlePath)
                    let rawString = String(data: jsonData, encoding: .utf8)
                    let formatedString = rawString?.trimmingCharacters(in: .whitespacesAndNewlines)
                    EngagementTriggerHelper.renderInAppTriggerFromJSONString(rawString!)
                }else{
                    print("file not found")
                }
            } catch {
                print(error)
            }
    }
}
