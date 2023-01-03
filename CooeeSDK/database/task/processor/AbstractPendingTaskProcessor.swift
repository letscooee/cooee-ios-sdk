//
//  AbstractPendingTaskProcessor.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 07/10/21.
//

import Foundation
import HandyJSON

class AbstractPendingTaskProcessor<T: HandyJSON>: PendingTaskProcessor {

    func process(_ task: PendingTasks) {
    }

    func canProcess(_ task: PendingTasks) -> Bool {
        return false
    }

    /**
     Deserialize the {@link PendingTask#data} to the Java Object of Type {@link T}
     - Parameter task: The pending task to deserialize.
     - Returns: Deserialized Java object of given type {@link T}.
     */
    func deserialize(_ task: PendingTasks) -> T {
        if let decodedTask = T.deserialize(from: task.data) {
            return decodedTask
        }

        return [String: Any]() as! T
    }

    /**
     Delete the given task which was successfully executed/completed.
     - Parameter task: Task to delete.
     */
    func deleteTask(_ task: PendingTasks) {
        PendingTaskDAO().delete(task)
    }

    /**
     If a task execution fails, update it {@link PendingTask#attempts} & {@link PendingTask#lastAttempted}.
     - Parameter task: Task to update.
     */
    func updateAttempted(_ task: PendingTasks) {
        task.attempts = task.attempts + 1
        task.lastAttempted = Date()
        PendingTaskDAO().update(task)
    }
}
