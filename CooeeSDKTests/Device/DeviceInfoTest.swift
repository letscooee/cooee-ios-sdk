//
//  DeviceInfoTest.swift
//  CooeeSDKTests
//
//  Created by Ashish Gaikwad on 04/04/22.
//

@testable import CooeeSDK
import XCTest

/**
 All below test cases are run on iPhone 13 Pro simulator. If device changed will lead to to failure in some cases like storage, RAM, etc.
 Cases like available RAM, Storage is skipped because value can be vary in while runtime.
 */
class DeviceInfoTest: XCTestCase {
    var deviceInfo: DeviceInfo!

    override func setUpWithError() throws {
        deviceInfo = DeviceInfo.shared
    }

    override func tearDownWithError() throws {
        deviceInfo = nil
    }

    func test_device_manufacturer() {
        let manufacturer = deviceInfo.cachedInfo.manufacture

        XCTAssert(manufacturer == "Apple")
    }

    func test_device_model() {
        let deviceModel = deviceInfo.cachedInfo.deviceModel
        XCTAssert(deviceModel == "iPhone Simulator")
    }

    func test_device_network_type() {
        let networkType = deviceInfo.cachedInfo.networkType
        XCTAssert(networkType == "Unknown")
    }

    func test_device_network_provider() {
        let networkProvider = deviceInfo.cachedInfo.networkProvider
        XCTAssert(networkProvider == "Unknown")
    }

    func test_device_network_total_storage() {
        let totalSpace = deviceInfo.cachedInfo.totalSpace
        XCTAssert(totalSpace == 476282)
    }

    func test_device_network_total_ram() {
        let totalRAM = deviceInfo.cachedInfo.totalRAM
        XCTAssert(totalRAM == 8192)
    }

    func test_device_os_version() {
        let osVersion = deviceInfo.cachedInfo.osVersion
        XCTAssert(osVersion == "15.4.0")
    }

    func test_device_name() {
        let deviceName = deviceInfo.cachedInfo.name
        XCTAssert(deviceName == "iPhone 12 Pro")
    }

    func test_device_is_bluetooth_turned_on() {
        let isBluetoothOn = deviceInfo.cachedInfo.isBTOn
        XCTAssert(isBluetoothOn == false)
    }

    func test_device_is_ar_supported() {
        let isARSupported = deviceInfo.cachedInfo.arSupport
        XCTAssert(isARSupported == false)
    }

    func test_device_orientation() {
        let orientation = deviceInfo.cachedInfo.deviceOrientation
        XCTAssert(orientation == "Portrait")
    }

    func test_device_is_wifi_on() {
        let isWIFIConnected = deviceInfo.cachedInfo.isWIFIConnected
        XCTAssert(isWIFIConnected == true)
    }

    func test_device_device_height() {
        let height = deviceInfo.cachedInfo.height
        XCTAssert(height == 844)
    }

    func test_device_device_width() {
        let width = deviceInfo.cachedInfo.width
        XCTAssert(width == 390)
    }

    func test_device_device_battery_charged_in_percent() {
        let battery = deviceInfo.cachedInfo.deviceBattery
        XCTAssert(battery == -100)
    }

    func test_device_device_battery_charging() {
        let isBatteryCharging = deviceInfo.cachedInfo.isBatteryCharging
        XCTAssert(isBatteryCharging == false)
    }
}
