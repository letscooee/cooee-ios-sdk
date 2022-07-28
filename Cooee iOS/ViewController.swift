//
//  ViewController.swift
//  Cooee iOS
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import CooeeSDK
import HandyJSON
import UIKit

class ViewController: UIViewController, CooeeCTADelegate {
    let cooeeSDK = CooeeSDK.getInstance()

    @IBOutlet var parentView: UIView!

    func onCTAResponse(payload: [String: Any]) {
        print(payload)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIGraphicsBeginImageContext(parentView.frame.size)
        UIImage(named: "banner")?.draw(in: view.bounds)

        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            parentView.backgroundColor = UIColor(patternImage: image)
        } else {
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }

        cooeeSDK.setOnCTADelegate(self)
        cooeeSDK.setCurrentScreen(screenName: "Main")

        do {
            try cooeeSDK.updateUserProfile(["name": "Ashish Gaikwad", "email": "ashish@iostest.com", "mobile": 9874563210])
        } catch {
            NSLog("\(error.localizedDescription)")
        }
    }

    @IBAction func loadPayload(_ sender: Any) {
        do {
            let eventProperties = [
                "item": [
                    "product_id": "1234",
                    "product_name": "Brush"
                ],
                "items": [
                    [
                        "product_id": "1234",
                        "product_name": "Brush"
                    ],
                    [
                        "product_id": "1234",
                        "product_name": "Brush"
                    ]
                ],
                "stringValue": "This is test String",
                "intValue": 1234567,
                "booleanValue": true,
                "doubleValue": 123.123
            ] as [String: Any]

            try cooeeSDK.sendEvent(eventName: "Add To Cart")
            try cooeeSDK.sendEvent(eventName: "Add To Cart", eventProperties: eventProperties)
        } catch {
            print(error)
        }
    }
    
    @IBAction func copyUserID(_ sender: Any) {
        UIPasteboard.general.string = cooeeSDK.getUserID()
        print("User ID: \(cooeeSDK.getUserID() ?? "")")
    }
}

public extension Dictionary {
    func percentEncoded() -> Data? {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        return jsonData
    }
}
