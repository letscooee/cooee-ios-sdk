//
//  PendingTaskJob.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 12/10/21.
//

import Foundation

class PendingTaskJob: PendingTaskJobProcessor {
    func startJob() {
        NSLog("\(Constants.TAG) PendingTaskJob running")
        let deviceAuthService = CooeeFactory.shared.deviceAuthService
        if !deviceAuthService.hasToken() {
            NSLog("\(Constants.TAG) Abort PendingTaskJob. Do not have the SDK token")
            return
        }

        let taskList = PendingTaskDAO().fetchTasks()
        CooeeFactory.shared.pendingTaskService.processTasks(pendingTasks: taskList)
    }
}
