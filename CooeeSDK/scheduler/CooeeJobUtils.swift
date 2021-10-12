//
//  CooeeJobUtils.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 12/10/21.
//

import Foundation

/**
 Schedules {@link PendingTaskJob}.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class CooeeJobUtils {
    // MARK: Public

    public static func schedulePendingTaskJob() {
        scheduleJob(latencyMillis: CooeeJobUtils.PENDING_JOB_INTERVAL_MILLIS)
    }

    public static func triggerPendingTaskJobImmediately() {
        print("Run PendingTaskJob immediately")
        scheduleJob(latencyMillis: 0)
    }

    /**
     Schedule a job with Android Service.

     - Parameter latencyMillis: latency/delay for the job execution.
     */
    public static func scheduleJob(latencyMillis: Int) {
        let timer = DispatchSource.makeTimerSource()
        timer.setEventHandler {
            PendingTaskJob().startJob()
        }
        if latencyMillis == 0 {
            timer.schedule(deadline: .now() + .seconds(latencyMillis), repeating: .never, leeway: .seconds(0))
        } else {
            timer.schedule(deadline: .now() + .seconds(latencyMillis), repeating: .seconds(latencyMillis), leeway: .seconds(60))
        }
        timer.activate()
    }

    // MARK: Private

    private static let PENDING_JOB_INTERVAL_MILLIS = 2 * 60
}
