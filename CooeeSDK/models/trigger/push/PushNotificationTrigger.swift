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

    public func getTitle()->TextElement? {
        title
    }

    public func getBody()->TextElement? {
        body
    }
    
    public func getSmallImage()->String? {
        smallImage
    }

    // MARK: Private

    private var title: TextElement?
    private var body: TextElement?
    private var smallImage: String?
    private var largeImage: String?
    private var buttons: [ButtonElement]?
}
