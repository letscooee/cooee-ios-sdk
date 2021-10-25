//
// Created by Ashish Gaikwad on 11/10/21.
//

import Foundation

/**
 A singleton service for utility over {@link PendingTask}.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class PendingTaskService {
    // MARK: Lifecycle

    init() {
        self.pendingTaskDAO = PendingTaskDAO()
        // self.instantiateProcessors()
    }

    // MARK: Public

    public func newTask(_ event: Event) -> PendingTasks {
        self.newTask(data: event.toJSONString()!, pendingTaskType: .API_SEND_EVENT)
    }

    public func newTask(data: [String: Any], pendingTaskType: PendingTaskType) -> PendingTasks {
        let jsonData = data.percentEncoded()
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return self.newTask(data: jsonString!, pendingTaskType: pendingTaskType)
    }

    /**
     Create a new pending task to be processed later by {@link PendingTaskJob} and {@link PendingTaskProcessor}.
     - Parameters:
       - data: The raw JSON data to be stored for later processing.
       - pendingTaskType: The type of pending task which can be processed by {@link PendingTaskProcessor}.
     - Returns: The created pending task.
     */
    public func newTask(data: String, pendingTaskType: PendingTaskType) -> PendingTasks {
        let pendingTaskModel = PendingTaskModel(data: data, type: pendingTaskType)
        return self.pendingTaskDAO.insert(pendingTaskModel)
    }

    public func processTask(pendingTask: PendingTasks) {
        for taskProcessor in PendingTaskService.PROCESSORS {
            if taskProcessor.canProcess(pendingTask) {
                taskProcessor.process(pendingTask)
                return
            }
        }
    }

    // MARK: Internal

    /**
     Process the given list of {@link PendingTask} via {@link PendingTaskProcessor}.

     - Parameter pendingTasks: The list of tasks.
     */
    func processTasks(pendingTasks: [PendingTasks]?) {
        if pendingTasks == nil || pendingTasks!.isEmpty {
            return
        }

        for task in pendingTasks! {
            self.processTask(pendingTask: task)
        }
    }

    // MARK: Private

    private static let PROCESSORS: [PendingTaskProcessor] = [EventTaskProcessor(), ProfileTaskProcessor(), PushTokenTaskProcessor(), SessionConcludeTaskProcessor()]

    private var pendingTaskDAO: PendingTaskDAO
}
