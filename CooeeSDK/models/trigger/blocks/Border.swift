//
//  Border.swift
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
struct Border: HandyJSON {
    // MARK: Public

    public enum Style {
        case SOLID, DASH
    }

    // MARK: Internal

    var radius: String?
    var width: String?
    var dashWidth: String?
    var dashGap: String?
    var colour: Colour?
    var style: Style?
}
