//
//  ViewController.swift
//  Cooee iOS
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import CooeeSDK
import Sentry
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

        SentrySDK.capture(message: "Dummy crash")
    }
}
