//
// Created by Ashish Gaikwad on 11/10/21.
//

import Foundation

/**
 Process a {@link PendingTask} which is the HTTP post call to server for concluding a session.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class SessionConcludeTaskProcessor: HttpTaskProcessor<DictionaryPrototype> {

    override func doHttp(data: DictionaryPrototype) throws {
        try baseHttpService.sendSessionConcludedEvent(body: data.toDictionary())
    }

    override func canProcess(_ task: PendingTasks) -> Bool {
        PendingTaskType.withLabel(task.type!) == PendingTaskType.API_SESSION_CONCLUDE
    }
}