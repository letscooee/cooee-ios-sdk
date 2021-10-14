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
        if latencyMillis == 0 {
            Timer.scheduledTimer(timeInterval: TimeInterval(latencyMillis), target: self,
                                 selector: #selector(triggerJob), userInfo: nil, repeats: false)
        } else {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(latencyMillis), target: self,
                                         selector: #selector(triggerJob), userInfo: nil, repeats: true)
        }
    }

    // MARK: Internal

    static var timer: Timer?

    // MARK: Private

    private static let PENDING_JOB_INTERVAL_MILLIS = 2 * 60

    @objc private static func triggerJob() {
        PendingTaskJob().startJob()
    }
}
