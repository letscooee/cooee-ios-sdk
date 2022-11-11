//
// Created by Ashish Gaikwad on 11/10/21.
//

import Foundation
import HandyJSON

/**
 Process a {@link PendingTask} which is related to updating user properties to backend API.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class ProfileTaskProcessor: HttpTaskProcessor<Dictionary<String, Any>> {
    override func deserialize(_ task: PendingTasks) -> Dictionary<String, Any> {
        guard let decodedData = task.data?.convertToDictionary() else {
            return [:]
        }
        
        return decodedData
    }

    override func doHttp(data: [String: Any]) throws {
        try baseHttpService.updateUserProfile(requestData: data)
    }

    override func canProcess(_ task: PendingTasks) -> Bool {
        PendingTaskType.withLabel(task.type!) == PendingTaskType.API_UPDATE_PROFILE
    }
}

extension Dictionary: HandyJSON {
}
