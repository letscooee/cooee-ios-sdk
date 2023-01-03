// 
// LogoutTaskProcessor.swift
// CooeeSDK
//
// Created by Ashish Gaikwad on 11/11/22.
//

import Foundation
import HandyJSON

class LogoutTaskProcessor: HttpTaskProcessor<String> {
    override func doHttp(data: String) throws {
        try super.baseHttpService.logoutUser()
    }

    override func canProcess(_ task: PendingTasks) -> Bool {
        PendingTaskType.withLabel(task.type!) == PendingTaskType.API_LOGOUT
    }

    override func deserialize(_ task: PendingTasks) -> String {
        return ""
    }
}

extension String: HandyJSON {
}
