//
//  PendingTaskConstants.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 07/10/21.
//

import Foundation

/**
 Constant for Pending Task table

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct PendingTaskConstants {
    static let TABLE_NAME = "pending_task"
    static let ID = "id"
    static let ATTEMPTS = "attempts"
    static let DATE_CREATED = "dateCreated"
    static let DATA = "data"
    static let LAST_ATTEMPTED = "lastAttempted"
    static let TYPE = "type"
}
