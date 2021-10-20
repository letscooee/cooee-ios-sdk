//
//  BaseTextElement.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 19/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class BaseTextElement: BaseElement {
    // MARK: Lifecycle

    required init() {}

    // MARK: Internal

    var text: String?
    var alignment: Alignment?
    var font: Font?
    var colour: Colour?
}
