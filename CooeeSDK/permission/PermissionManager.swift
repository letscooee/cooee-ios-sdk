//
//  PermissionManager.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 04/02/22.
//

import AVFoundation
import CoreLocation
import Foundation
import UserNotifications

class PermissionManager {
    // MARK: Lifecycle

    init() {
        permissions = PermissionType.allCases
    }

    // MARK: Internal

    func getPermissionInformation() -> [String: Any]? {
        deviceProps = [String: Any]()
        permissionDetails = [String: Any]()

        for permission in permissions {
            if permission == .LOCATION {
                checkLocationPermissionAndFetchDetails()
            } else if permission == .PUSH {
                checkPushNotificationPermission()
            } else if permission == .STORAGE {
                // No need to access storage till we need access other directory in internal sorage
                // iOS provide access to app specific directory and some common shared directory
                // Hence we do not need this STORAGE permission in iOS
                permissionDetails?.updateValue("GRANTED", forKey: permission.rawValue)
            } else if permission == .PHONE_DETAILS {
                // This permission Android specific and require to access network type.
                // iOS by default grant this permission
                permissionDetails?.updateValue("GRANTED", forKey: permission.rawValue)
            } else if permission == .CAMERA {
                checkCameraPermission()
            }
        }

        deviceProps?.updateValue(permissionDetails!, forKey: "perm")

        return deviceProps
    }

    // MARK: Private

    private let permissions: [PermissionType]
    private var deviceProps: [String: Any]?
    private var permissionDetails: [String: Any]?

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                permissionDetails?.updateValue("GRANTED", forKey: PermissionType.CAMERA.rawValue)
                return

            default:
                permissionDetails?.updateValue("DENIED", forKey: PermissionType.CAMERA.rawValue)
        }
    }

    private func checkPushNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        let semaspore = DispatchSemaphore(value: 0)
        var notificationSettings: UNNotificationSettings?

        notificationCenter.getNotificationSettings(completionHandler: { settings in
            notificationSettings = settings
            semaspore.signal()
        })
        
        semaspore.wait()
        
        switch notificationSettings?.authorizationStatus {
            case .authorized, .provisional:
                permissionDetails?.updateValue("GRANTED", forKey: PermissionType.PUSH.rawValue)
                return
            default:
                permissionDetails?.updateValue("DENIED", forKey: PermissionType.PUSH.rawValue)
        }
    }

    private func checkLocationPermissionAndFetchDetails() {
        let status = CLLocationManager.authorizationStatus()

        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                permissionDetails?.updateValue("GRANTED", forKey: PermissionType.LOCATION.rawValue)
                fetchLocationInformationAndAdd()
                return
            default:
                permissionDetails?.updateValue("DENIED", forKey: PermissionType.LOCATION.rawValue)
        }
    }

    private func fetchLocationInformationAndAdd() {
        let locationManager = CLLocationManager()

        guard let location = locationManager.location else {
            return
        }

        let locationInfo = [location.coordinate.latitude, location.coordinate.longitude]

        deviceProps?.updateValue(locationInfo, forKey: "coords")
    }
}
