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
    }
}
