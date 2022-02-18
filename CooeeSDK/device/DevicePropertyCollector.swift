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
    // MARK: Lifecycle

    init() {
        permissionManager = PermissionManager()
    }

    // MARK: Public

    public func getMutableDeviceProps() -> [String: Any?] {
        let storage = [
            "tot": deviceInfo.cachedInfo.totalSpace,
            "avl": deviceInfo.cachedInfo.freeSpace
        ]

        let memory = [
            "tot": deviceInfo.cachedInfo.totalRAM,
            "avl": deviceInfo.cachedInfo.availableRAM
        ] as [String: Any]

        let os = [
            "ver": deviceInfo.cachedInfo.osVersion,
            "name": Constants.PLATFORM
        ]

        let battery = [
            "c": deviceInfo.cachedInfo.isBatteryCharging,
            "l": deviceInfo.cachedInfo.deviceBattery
        ] as [String: Any]

        let network = [
            "opr": deviceInfo.cachedInfo.networkProvider,
            "type": deviceInfo.cachedInfo.networkType
        ] as [String: Any]

        var deviceProperties = [
            "storage": storage,
            "mem": memory,
            "os": os,
            "bat": battery,
            "net": network,
            "locale": Bundle.main.preferredLocalizations[0],
            "bt": deviceInfo.cachedInfo.isBTOn,
            "wifi": deviceInfo.cachedInfo.isWIFIConnected,
            "orientation": deviceInfo.cachedInfo.deviceOrientation
        ] as [String: Any]
        
        deviceProperties.merge(permissionManager.getPermissionInformation() ?? [String: Any]()){(current,_) in current}
        
        return deviceProperties
    }

    // MARK: Internal

    func getImmutableDeviceProps() -> [String: Any] {
        let display = [
            "w": deviceInfo.cachedInfo.width,
            "h": deviceInfo.cachedInfo.height,
            "dpi": deviceInfo.cachedInfo.dpi
        ]

        let device = [
            "model": deviceInfo.cachedInfo.deviceModel,
            "vender": deviceInfo.cachedInfo.manufacture
        ]

        return [
            "display": display,
            "device": device,
            "ar": deviceInfo.cachedInfo.arSupport
        ]
    }

    func getAppInstallDate() -> String? {
        DateUtils.formatDateToUTCString(date: appInfo.cachedInfo.installDate ?? Date())
    }

    // MARK: Private

    private let deviceInfo = DeviceInfo.shared
    private let appInfo = AppInfo.shared
    private let sdkInfo = SDKInfo.shared
    private let permissionManager: PermissionManager
}
