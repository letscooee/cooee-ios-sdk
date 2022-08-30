//
//  DebugInfoCollector.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 22/08/22.
//

import Foundation

/**
 Collect all the debug information.

 - Author: Ashish Gaikwad
 - Since: 1.3.17
 */
class DebugInfoCollector {
    // MARK: Lifecycle

    init() {
        deviceInformation = [DebugInformation]()
        userInformation = [DebugInformation]()
        deviceInfo = CooeeFactory.shared.deviceInfo
        appInfo = CooeeFactory.shared.appInfo
        collectDeviceInfo()
        collectUserInfo()
    }

    // MARK: Internal

    var deviceInformation: [DebugInformation]
    var userInformation: [DebugInformation]

    /**
     Collect all User information and add it to ``deviceInformation``
     */
    func collectDeviceInfo() {
        deviceInformation.append(DebugInformation(key: "Device Name", value: deviceInfo.getDeviceName()))
        deviceInformation.append(DebugInformation(key: "SDK Version", value: "\(Constants.VERSION_STRING)+\(Constants.VERSION_CODE)"))
        deviceInformation.append(DebugInformation(key: "App Version", value: appInfo.getAppVersion()))
        deviceInformation.append(DebugInformation(key: "Bundle ID", value: appInfo.getAppPackage()))
        deviceInformation.append(DebugInformation(key: "Install Date", value: appInfo.getInstalledDate() ?? notAvailable))
        deviceInformation.append(DebugInformation(key: "Build Date", value: appInfo.getBuildTime() ?? notAvailable))
        deviceInformation.append(DebugInformation(key: "Push Token", value: notAvailable, sharable: true))
        deviceInformation.append(DebugInformation(key: "Device ID", value: LocalStorageHelper.getString(key: Constants.STORAGE_DEVICE_ID) ?? notAvailable, sharable: true))
        deviceInformation.append(DebugInformation(key: "Resolution", value: "\(deviceInfo.getDeviceWidth())x\(deviceInfo.getDeviceHeight())"))
    }

    /**
     Collect all User information and add it to ``userInformation``
     */
    func collectUserInfo() {
        userInformation.append(DebugInformation(key: "User ID", value: LocalStorageHelper.getString(key: Constants.STORAGE_USER_ID) ?? "NA", sharable: true))
    }

    // MARK: Private

    private let appInfo: AppInfo
    private let deviceInfo: DeviceInfo
    private let notAvailable = "NA"
}
