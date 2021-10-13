//
//  PendingTaskProcessor.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 07/10/21.
//

import Foundation

/**
 Skeleton of a {@link PendingTask} processor.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
protocol PendingTaskProcessor {

    func process(_ task: PendingTasks)

    func canProcess(_ task: PendingTasks) -> Bool
}
