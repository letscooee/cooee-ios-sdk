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
 - Since: 1.3.0
 */
struct ClickAction: HandyJSON {
    // MARK: Public

    
    public func isOnlyCloseCTA() -> Bool {
        return iab == nil && ext == nil && updt == nil && pmpt == nil && up == nil && kv == nil && share == nil && open == nil
    }

    // MARK: Internal

    var iab: BrowserContent?
    var ext: BrowserContent?
    var updt: BrowserContent?
    var pmpt: PermissionType?
    var up: [String: Any]?
    var kv: [String: Any]?
    var share: [String: Any]?
    var close: Bool? = false
    var ntvAR: AppAR?
    var open: Int?
}
