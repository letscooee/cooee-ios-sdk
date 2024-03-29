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
    // MARK: Lifecycle

    init() {}

    init(shouldClose: Bool) {
        self.close = shouldClose
    }

    // MARK: Public

    public func isOnlyCloseCTA() -> Bool {
        return iab == nil && ext == nil && updt == nil && pmpt == nil && up == nil && kv == nil && custKV == nil && share == nil && open == nil
    }

    // MARK: Internal

    var iab: BrowserContent?
    var ext: BrowserContent?
    var updt: BrowserContent?
    var pmpt: Int?
    var up: [String: Any]?
    var kv: [String: Any]?
    var custKV: [String: Any]?
    var share: ShareContent?
    var close: Bool? = false
    var ntvAR: AppAR?
    var open: Int?
}
