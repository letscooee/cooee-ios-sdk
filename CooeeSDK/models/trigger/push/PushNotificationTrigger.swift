//
//  PushNotificationTrigger.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/12/21.
//

import Foundation
import HandyJSON

struct PushNotificationTrigger: HandyJSON {
    // MARK: Public

    public func getTitle() -> TextElement? {
        t
    }

    public func getBody() -> TextElement? {
        b
    }

    public func getSmallImage() -> String? {
        si
    }

    // MARK: Private

    private var t: TextElement?
    private var b: TextElement?
    private var si: String?
    private var li: String?
    private var btns: [ButtonElement]?
}
