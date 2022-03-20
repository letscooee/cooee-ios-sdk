//
//  SentryTransaction.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 10/03/22.
//

import Foundation

/**
 SentryTransaction represents a transaction in Sentry.

 - Author: Ashish Gaikwad
 - Since: 1.3.13
 */
enum SentryTransaction: String, CaseIterable {

    case COOEE_INAPP_SCENE = "CooeeInAppScene"
    case COOEE_FACTORY_INIT = "CooeeFactory.init()"

    /**
     Returns list if values for all ``case`` in ``SentryTransaction``.

     - Returns: List of all values for all ``case`` in ``SentryTransaction``.
     */
    static func valueList() -> [String] {
        var array: [String] = []
        for item in allCases {
            array.append(item.rawValue)
        }
        return array
    }
}
