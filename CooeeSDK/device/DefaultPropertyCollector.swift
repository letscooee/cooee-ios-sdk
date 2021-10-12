//
//  DefaultPropertyCollector.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation

/**
 Make collection of all properties at one location

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class DefaultPropertyCollector {
    // MARK: Public

    public func getCommonEventProperties() -> [String: Any?] {
        var eventProperties = [String: Any?]()
        eventProperties["CE App Version"] = appInfo.cachedInfo.version
        eventProperties["CE SDK Version"] = sdkInfo.cachedInfo.sdkVersion
        eventProperties["CE OS Version"] = deviceInfo.cachedInfo.osVersion
        eventProperties["CE Network Provider"] = deviceInfo.cachedInfo.networkProvider
        eventProperties["CE Network Type"] = deviceInfo.cachedInfo.networkType
        eventProperties["CE Bluetooth On"] = deviceInfo.cachedInfo.isBTOn
        eventProperties["CE Wifi Connected"] = deviceInfo.cachedInfo.isWIFIConnected
        eventProperties["CE Device Battery"] = deviceInfo.cachedInfo.deviceBattery

        return eventProperties
    }

    // MARK: Internal

    func getDefaultVales() -> [String: Any] {
        var userProperty = [String: Any]()

        userProperty["CE Device Orientation"] = deviceInfo.cachedInfo.deviceOrientation
        userProperty["CE Device Model"] = deviceInfo.cachedInfo.deviceModel
        userProperty["CE Device Manufacture"] = "Apple"
        userProperty["CE Available Internal Memory"] = deviceInfo.cachedInfo.freeSpace
        userProperty["CE Total Internal Memory"] = deviceInfo.cachedInfo.totalSpace
        userProperty["CE Device Battery"] = deviceInfo.cachedInfo.deviceBattery
        userProperty["CE Network Provider"] = deviceInfo.cachedInfo.networkProvider
        userProperty["CE Network Type"] = deviceInfo.cachedInfo.networkType
        userProperty["CE Bluetooth On"] = deviceInfo.cachedInfo.isBTOn
        userProperty["CE Wifi Connected"] = deviceInfo.cachedInfo.isWIFIConnected
        userProperty["CE OS"] = "IOS"
        userProperty["CE OS Version"] = deviceInfo.cachedInfo.osVersion
        userProperty["CE SDK Version"] = sdkInfo.cachedInfo.sdkVersion + "+" + sdkInfo.cachedInfo.sdkLongVersion
        userProperty["CE App Version"] = appInfo.cachedInfo.version
        userProperty["CE Screen Resolution"] = "\(deviceInfo.getDeviceWidth())x\(deviceInfo.getDeviceHeight())"
        userProperty["CE Package Name"] = "\(appInfo.getAppPackage())"
        userProperty["CE Total RAM"] = (deviceInfo.cachedInfo.totalSpace)
        userProperty["CE Available RAM"] = deviceInfo.cachedInfo.availableRAM
        userProperty["CE DPI"] = deviceInfo.cachedInfo.dpi
        userProperty["CE App Version"] = appInfo.cachedInfo.version

        return userProperty
    }

    func getAppInstallDate() -> String? {
        DateUtils.formatDateToUTCString(date: appInfo.cachedInfo.installDate ?? Date())
    }

    // MARK: Private

    private let deviceInfo = DeviceInfo.shared
    private let appInfo = AppInfo.shared
    private let sdkInfo = SDKInfo.shared
}
