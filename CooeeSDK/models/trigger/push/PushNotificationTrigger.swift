//
//  PushNotificationTrigger.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/12/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 1.0.1
 */
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

    public func getClickAction() -> ClickAction? {
        clc
    }

    // MARK: Private

    private var t: TextElement?
    private var b: TextElement?
    private var si: String?
    private var li: String?
    private var btns: [ButtonElement]?
    private var clc: ClickAction?
}
