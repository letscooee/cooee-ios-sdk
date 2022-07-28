//
// Created by Ashish Gaikwad on 11/10/21.
//

import Foundation
import HandyJSON

/**
 An abstract layer to process all {@link PendingTask} which is related to HTTP API interaction.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class HttpTaskProcessor<T: HandyJSON>: AbstractPendingTaskProcessor<T> {

    let baseHttpService = CooeeFactory.shared.baseHttpService
    let deviceAuthService = CooeeFactory.shared.deviceAuthService

    /**
     Make the <strong>synchronous</strong> HTTP call to the service via {@link BaseHTTPService}.

     - Parameter data: The data to pass to the HTTP API.
     - Throws: CustomError# if HTTP request fails because of any reason.
     */
    func doHttp(data: T) throws {
    }

    /**
     This method will deserialize the {@link PendingTask#data} and send it to HTTP API via {@link #doHTTP(Object)}
     which is a synchronous call. If that call succeeds, delete the given {@link PendingTask}, otherwise, it will
     just update the {@link PendingTask} as attempted via {@link #updateAttempted(PendingTask)}
     - Parameter task: Task to process.
     */
    override func process(_ task: PendingTasks) {
        NSLog("Processing Task: \(task.id)")
        let data = deserialize(task)

        if !(deviceAuthService.hasToken()) {
            NSLog("Don't have SDK token. Abort processing \(task.id)")
            return
        }

        do {
            try doHttp(data: data)
            deleteTask(task)
        } catch _ {
            updateAttempted(task)
        }
    }
}
