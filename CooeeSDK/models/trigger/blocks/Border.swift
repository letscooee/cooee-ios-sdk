//
//  Border.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Border: Codable {
    // MARK: Public

    public enum Style: Codable {
        case SOLID, DASH
    }

    // MARK: Internal

    let radius: String?
    let width: String?
    let dashWidth: String?
    let dashGap: String?
    let colour: Colour
    let style: Style
}
