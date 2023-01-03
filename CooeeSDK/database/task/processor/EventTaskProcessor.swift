//
// Created by Ashish Gaikwad on 11/10/21.
//

import Foundation

/**
 Process a {@link PendingTask} which is related to pushing an {@link Event} to API.
 
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class EventTaskProcessor: HttpTaskProcessor<Event> {

    override func deserialize(_ task: PendingTasks) -> Event {
        guard let decodedTask = Event.deserialize(from: task.data) else {
            return Event()
        }

        return decodedTask
    }

    override func doHttp(data: Event) throws {
        try baseHttpService.sendEvent(event: data)
    }

    override func canProcess(_ task: PendingTasks) -> Bool {
        PendingTaskType.withLabel(task.type!) == PendingTaskType.API_SEND_EVENT
    }
}