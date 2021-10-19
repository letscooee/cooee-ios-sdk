//
//  Size.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Size: Codable {
    // MARK: Lifecycle

    init() {
        self.display=Display.BLOCK
    }

    // MARK: Public

    public enum Display: Codable {
        case BLOCK, INLINE_BLOCK, FLEX, INLINE_FLEX
    }

    // MARK: Internal

    var width: String?=nil
    var height: String?=nil
    var maxWidth: String?=nil
    var maxHeight: String?=nil
    var display: Display?=nil
    var justifyContent: FlexProperty.JustifyContent?=nil
    var alignItems: FlexProperty.AlignItems?=nil
    var wrap: FlexProperty.Wrap?=nil
    var alignContent: FlexProperty.AlignContent?=nil
    var direction: FlexProperty.Direction?=nil
}
