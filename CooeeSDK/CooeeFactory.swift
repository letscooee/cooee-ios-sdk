//
//  CooeeFactory.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import Foundation
import Sentry

/**
 A factory pattern utility class to provide the singleton instances of various classes.
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class CooeeFactory {
    // MARK: Lifecycle

    init() {
        appInfo = AppInfo.shared
        deviceInfo = DeviceInfo.shared
        infoPlistReader = InfoPlistReader.shared
        sdkInfo = SDKInfo.shared
        sentryHelper = SentryHelper(appInfo, sdkInfo, infoPlistReader)
        sentryHelper.initSentry()

        let transaction = SentrySDK.startTransaction(
            name: "CooeeFactory.init()",
            operation: "task"
        )

        sessionManager = SessionManager.shared
        baseHttpService = BaseHTTPService.shared
        userAuthService = UserAuthService.shared
        userAuthService.acquireSDKToken()
        pendingTaskService = PendingTaskService()
        runtimeData = RuntimeData.shared
        safeHttpService = SafeHTTPService(pendingTaskService: pendingTaskService, sessionManager: sessionManager, runtimeData: runtimeData)
        
        transaction.finish()
    }

    // MARK: Internal

    static let shared = CooeeFactory()

    let appInfo: AppInfo
    let deviceInfo: DeviceInfo
    let infoPlistReader: InfoPlistReader
    let userAuthService: UserAuthService
    let baseHttpService: BaseHTTPService
    let sdkInfo: SDKInfo
    let sessionManager: SessionManager
    let safeHttpService: SafeHTTPService
    let pendingTaskService: PendingTaskService
    let runtimeData: RuntimeData
    let sentryHelper: SentryHelper
}