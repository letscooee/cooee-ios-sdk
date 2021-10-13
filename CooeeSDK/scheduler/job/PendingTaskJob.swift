//
//  PendingTaskJob.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 12/10/21.
//

import Foundation

class PendingTaskJob: PendingTaskJobProcessor {
    func startJob() {
        print("PendingTaskJob running")
        let deviceAuthService = CooeeFactory.shared.userAuthService
        if !deviceAuthService.hasToken() {
            print("Abort PendingTaskJob. Do not have the SDK token")
            return
        }

        let taskList = PendingTaskDAO().fetchTasks()
        CooeeFactory.shared.pendingTaskService.processTasks(pendingTasks: taskList)
    }
}
