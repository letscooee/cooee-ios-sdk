//
//  DebugInformation.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 22/08/22.
//

import Foundation

/**
 Holds debug information with its key and value

 - Author: Ashish Gaikwad
 - Since: 1.3.17
 */
struct DebugInformation {
    // MARK: Lifecycle

    init(key: String, value: String, sharable: Bool = false) {
        self.sharable = sharable
        self.key = key
        self.value = value
    }

    // MARK: Internal

    var key: String
    var value: String
    var sharable: Bool
}
