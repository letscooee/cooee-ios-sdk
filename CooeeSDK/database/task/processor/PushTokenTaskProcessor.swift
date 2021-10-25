//
// Created by Ashish Gaikwad on 11/10/21.
//

import Foundation

/**
 Process a {@link PendingTask} which is related to update the push notification token to the server.
 
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class PushTokenTaskProcessor: HttpTaskProcessor<DictionaryPrototype> {

    override func doHttp(data: DictionaryPrototype) throws {
        try baseHttpService.sendFirebaseToken(token: data.firebaseToken)
    }

    override func canProcess(_ task: PendingTasks) -> Bool {
        return PendingTaskType.withLabel(task.type!) == PendingTaskType.API_UPDATE_PUSH_TOKEN
    }
}
