//
//  DevicePropertyCollector.swift
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
class DevicePropertyCollector {
    // MARK: Public

    public func getCommonEventProperties() -> [String: Any?] {
        [
            "CE App Version": appInfo.cachedInfo.version,
            "CE SDK Version": sdkInfo.cachedInfo.sdkVersion,
            "CE OS Version": deviceInfo.cachedInfo.osVersion,
            "CE Network Provider": deviceInfo.cachedInfo.networkProvider,
            "CE Network Type": deviceInfo.cachedInfo.networkType,
            "CE Bluetooth On": deviceInfo.cachedInfo.isBTOn,
            "CE Wifi Connected": deviceInfo.cachedInfo.isWIFIConnected,
            "CE Device Battery": deviceInfo.cachedInfo.deviceBattery
        ]
    }

    // MARK: Internal

    func getDefaultValues() -> [String: Any] {
        [
            "CE Device Orientation": deviceInfo.cachedInfo.deviceOrientation,
            "CE Device Model": deviceInfo.cachedInfo.deviceModel,
            "CE Device Manufacture": "Apple",
            "CE Available Internal Memory": deviceInfo.cachedInfo.freeSpace,
            "CE Total Internal Memory": deviceInfo.cachedInfo.totalSpace,
            "CE Device Battery": deviceInfo.cachedInfo.deviceBattery,
            "CE Network Provider": deviceInfo.cachedInfo.networkProvider,
            "CE Network Type": deviceInfo.cachedInfo.networkType,
            "CE Bluetooth On": deviceInfo.cachedInfo.isBTOn,
            "CE Wifi Connected": deviceInfo.cachedInfo.isWIFIConnected,
            "CE OS": "IOS",
            "CE OS Version": deviceInfo.cachedInfo.osVersion,
            "CE SDK Version": "\(sdkInfo.cachedInfo.sdkVersion)+\(sdkInfo.cachedInfo.sdkLongVersion)",
            "CE App Version": appInfo.cachedInfo.version,
            "CE Screen Resolution": "\(deviceInfo.getDeviceWidth())x\(deviceInfo.getDeviceHeight())",
            "CE Package Name": "\(appInfo.getAppPackage())",
            "CE Total RAM": (deviceInfo.cachedInfo.totalSpace),
            "CE Available RAM": deviceInfo.cachedInfo.availableRAM,
            "CE DPI": deviceInfo.cachedInfo.dpi
        ]
    }

    func getAppInstallDate() -> String? {
        DateUtils.formatDateToUTCString(date: appInfo.cachedInfo.installDate ?? Date())
    }

    // MARK: Private

    private let deviceInfo = DeviceInfo.shared
    private let appInfo = AppInfo.shared
    private let sdkInfo = SDKInfo.shared
}
