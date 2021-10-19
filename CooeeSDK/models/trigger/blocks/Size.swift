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
    // MARK: Public

    public enum Display: Codable {
        case BLOCK, INLINE_BLOCK, FLEX, INLINE_FLEX
    }

    // MARK: Internal

    let width: String?
    let height: String?
    let maxWidth: String?
    let maxHeight: String?
    var display: Display? = Display.BLOCK
    let justifyContent: FlexProperty.JustifyContent?
    let alignItems: FlexProperty.AlignItems?
    let wrap: FlexProperty.Wrap?
    let alignContent: FlexProperty.AlignContent?
    let direction: FlexProperty.Direction?
}
