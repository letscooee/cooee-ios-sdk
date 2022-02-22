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

/**
  The PermissionManager class is used to check permission status.

 - Author: Ashish Gaikwad
 - Since: 1.3.8
 */
class PermissionManager {
    // MARK: Lifecycle

    init() {
    }

    // MARK: Internal

    /**
      Check if the permission is granted or not and add all data to to dictionary.

     - Returns: Dictionary of permission details and its related data.
     */
    func getPermissionInformation() -> [String: Any]? {
        deviceProps = [String: Any]()
        permissionDetails = [String: Any]()

        checkLocationPermissionAndFetchDetails()
        checkCameraPermission()

        // This permission Android specific and require to access network type.
        // iOS by default grant this permission
        permissionDetails?.updateValue(GRANTED, forKey: PermissionType.PHONE_DETAILS.rawValue)

        // No need to access storage till we need access other directory in internal storage
        // iOS provide access to app specific directory and some common shared directory
        // Hence we do not need this STORAGE permission in iOS
        permissionDetails?.updateValue(GRANTED, forKey: PermissionType.STORAGE.rawValue)

        checkPushNotificationPermission()

        deviceProps?.updateValue(permissionDetails!, forKey: "perm")

        return deviceProps
    }

    // MARK: Private

    private var deviceProps: [String: Any]?
    private var permissionDetails: [String: Any]?
    private let GRANTED = "GRANTED"
    private let DENIED = "DENIED"

    /**
     Check if the camera permission is granted or not and add value to dictionary.
     */
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                permissionDetails?.updateValue(GRANTED, forKey: PermissionType.CAMERA.rawValue)
                return

            default:
                permissionDetails?.updateValue(DENIED, forKey: PermissionType.CAMERA.rawValue)
        }
    }

    /**
     Check if the push notification permission is granted or not and add value to dictionary.
     */
    private func checkPushNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        let semaphore = DispatchSemaphore(value: 0)
        var notificationSettings: UNNotificationSettings?

        notificationCenter.getNotificationSettings(completionHandler: { settings in
            notificationSettings = settings
            semaphore.signal()
        })

        semaphore.wait()

        switch notificationSettings?.authorizationStatus {
            case .authorized, .provisional:
                permissionDetails?.updateValue(GRANTED, forKey: PermissionType.PUSH.rawValue)
                return
            default:
                permissionDetails?.updateValue(DENIED, forKey: PermissionType.PUSH.rawValue)
        }
    }

    /**
     Check if the location permission is granted or not and add value to dictionary.
     */
    private func checkLocationPermissionAndFetchDetails() {
        let status = CLLocationManager.authorizationStatus()

        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                permissionDetails?.updateValue(GRANTED, forKey: PermissionType.LOCATION.rawValue)
                fetchLocationInformationAndAdd()
                return
            default:
                permissionDetails?.updateValue(DENIED, forKey: PermissionType.LOCATION.rawValue)
        }
    }

    /**
     Fetch location information and add to dictionary.
     */
    private func fetchLocationInformationAndAdd() {
        let locationManager = CLLocationManager()

        guard let location = locationManager.location else {
            return
        }

        let locationInfo = [location.coordinate.latitude, location.coordinate.longitude]

        deviceProps?.updateValue(locationInfo, forKey: "coords")
    }
}
