//
// Created by Ashish Gaikwad on 07/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct PendingTaskModel {
    // MARK: Lifecycle

    init(data: String, type: PendingTaskType) {
        self.data = data
        self.type = type
        dateCreated = Date()
        attempts = 0
    }

    init(id: Int, attempts: Int, dateCreated: Date, data: String, lastAttempted: Date, type: PendingTaskType) {
        self.data = data
        self.type = type
        self.dateCreated = dateCreated
        self.attempts = attempts
        self.lastAttempted = lastAttempted
        self.id = id
    }

    // MARK: Internal

    var id: Int?
    var attempts: Int?
    var dateCreated: Date?
    var data: String
    var lastAttempted: Date?
    var type: PendingTaskType
    var sdkVersion: Int = SDKInfo.shared.cachedInfo.sdkVersionCode
}
