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
        title
    }

    public func getBody() -> TextElement? {
        body
    }

    public func getSmallImage() -> String? {
        smallImage?.isEmpty ?? true ? nil : smallImage
    }

    public func getLargeImage() -> String? {
        largeImage?.isEmpty ?? true ? nil : largeImage
    }

    public func getClickAction() -> ClickAction? {
        clickAction
    }

    public func getSubTitle() -> TextElement? {
        subTitle
    }

    mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &title, name: "t")
        mapper.specify(property: &body, name: "b")
        mapper.specify(property: &smallImage, name: "si")
        mapper.specify(property: &largeImage, name: "li")
        mapper.specify(property: &clickAction, name: "clc")
        mapper.specify(property: &subTitle, name: "st")
    }

    // MARK: Private

    private var title: TextElement?
    private var subTitle: TextElement?
    private var body: TextElement?
    private var smallImage: String?
    private var largeImage: String?
    private var btns: [ButtonElement]?
    private var clickAction: ClickAction?
}
