//
// Created by Ashish Gaikwad on 07/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct PendingTask {
    var id: Int? = nil
    var attempts: Int
    var dateCreated: Int64
    var data: String
    var lastAttempted: Int64? = nil
    var type: PendingTaskType


    init(data: String, type: PendingTaskType) {
        self.data = data
        self.type = type
        dateCreated = Int64(Date().timeIntervalSince1970)
        attempts = 0
    }

    init(id: Int, attempts: Int, dateCreated: Int64, data: String, lastAttempted: Int64, type: PendingTaskType) {
        self.data = data
        self.type = type
        self.dateCreated = dateCreated
        self.attempts = attempts
        self.lastAttempted = lastAttempted
        self.id = id
    }
}
