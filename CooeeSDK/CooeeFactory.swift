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
 - Since:0.1
 */
class CooeeFactory {
    static let shared = CooeeFactory()

    let appInfo: AppInfo
    let deviceInfo: DeviceInfo

    init() {
        appInfo = AppInfo.shared
        deviceInfo = DeviceInfo.shared
    }
}
