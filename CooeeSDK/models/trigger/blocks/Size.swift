//
//  Size.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Size: HandyJSON {
    // MARK: Lifecycle

//    init() {
//        self.display = Display.BLOCK
//    }

    // MARK: Public

    public enum Display {
        case BLOCK, INLINE_BLOCK, FLEX, INLINE_FLEX
    }

    // MARK: Internal

    var width: String?
    var height: String?
    var maxWidth: String?
    var maxHeight: String?
    var display: Display?
    var justifyContent: FlexProperty.JustifyContent?
    var alignItems: FlexProperty.AlignItems?
    var wrap: FlexProperty.Wrap?
    var alignContent: FlexProperty.AlignContent?
    var direction: FlexProperty.Direction?
}
