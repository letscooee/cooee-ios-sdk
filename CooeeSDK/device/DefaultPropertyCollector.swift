//
//  DefaultPropertyCollector.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation

class DefaultPropertyCollector {
    // MARK: Public

    public func getCommonEventProperties() -> [String: Any?] {
        var eventProperties = [String: Any?]()
        eventProperties["CE App Version"] = appInfo.cachedInfo.version
        eventProperties["CE SDK Version"] = sdkInfo.catchedInfo.sdkVersion
        eventProperties["CE OS Version"] = deviceInfo.cachedInfo.osVersion
        // eventProperties.put("CE Network Provider", networkData[0]);
        // eventProperties.put("CE Network Type", networkData[1]);
        // eventProperties.put("CE Bluetooth On", defaultUserPropertiesCollector.isBluetoothOn());
        // eventProperties.put("CE Wifi Connected", defaultUserPropertiesCollector.isConnectedToWifi());
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
        // userProperty["CE Network Provider"] = NetworkData.shared.getCarrierName()
        // userProperty["CE Network Type"] = NetworkData.shared.getNetworkType()
        // userProperty["CE Bluetooth On"] = isBTTurnedOn
        // userProperty["CE Wifi Connected"] = (NetworkData.shared.getNetworkType() == "WIFI") ? true : false
        userProperty["CE OS"] = "IOS"
        userProperty["CE OS Version"] = deviceInfo.cachedInfo.osVersion
        userProperty["CE SDK Version"] = sdkInfo.catchedInfo.sdkVersion+"+"+sdkInfo.catchedInfo.sdkLongVersion
        userProperty["CE App Version"] = appInfo.cachedInfo.version
        userProperty["CE Screen Resolution"] = "\(deviceInfo.getDeviceWidth())x\(deviceInfo.getDeviceHeight())"
        userProperty["CE Package Name"] = "\(appInfo.getAppPackage())"
        userProperty["CE Total RAM"] = (deviceInfo.cachedInfo.totalSpace)
        userProperty["CE Available RAM"] = deviceInfo.cachedInfo.availavleRAM
        userProperty["CE DPI"] = deviceInfo.cachedInfo.dpi
        userProperty["CE App Version"] = appInfo.cachedInfo.version

        return userProperty
    }

    func getAppInstallDate() -> Date? {
        appInfo.cachedInfo.installDate
    }

    // MARK: Private

    private let deviceInfo = DeviceInfo.shared
    private let appInfo = AppInfo.shared
    private let sdkInfo = SDKInfo.shared
}
