//
//  CooeeFactory.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import Foundation

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
        sessionManager = SessionManager.shared
        baseHttpService = BaseHTTPService.shared
        userAuthService = UserAuthService()
        userAuthService.acquireSDKToken()
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
}
