//
//  DeviceTaskProcessor.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/01/22.
//

import Foundation

/**
 Process a {@link PendingTask} which is related to updating user properties to backend API.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class DeviceTaskProcessor: HttpTaskProcessor<Dictionary<String, Any>> {

    override func deserialize(_ task: PendingTasks) -> Dictionary<String, Any> {
        guard let decodedData = task.data?.convertToDictionary() else {
            return [:]
        }

        return decodedData
    }

    override func doHttp(data: Dictionary<String, Any>) throws {
        try baseHttpService.updateDeviceProp(requestData: data)
    }

    override func canProcess(_ task: PendingTasks) -> Bool {
        PendingTaskType.withLabel(task.type!) == PendingTaskType.API_DEVICE_PROFILE
    }
}
