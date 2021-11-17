//
//  ClickAction.swift
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
struct ClickAction: HandyJSON {

    var iab: BrowserContent?
    var ext: BrowserContent?
    var updateApp: BrowserContent?
    var prompt: PermissionType?
    var up: [String: Any]?
    var kv: [String: Any]?
    var share: [String: Any]?
    var close: Bool? = false
    var appAR: AppAR?
}
