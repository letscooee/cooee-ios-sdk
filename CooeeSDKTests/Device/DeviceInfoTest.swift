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
        let manufacturer = deviceInfo.cachedInfo.deviceModel
        XCTAssert(manufacturer == "iPhone Simulator")
    }

    func test_device_network_type() {
        let manufacturer = deviceInfo.cachedInfo.networkType
        XCTAssert(manufacturer == "Unknown")
    }

    func test_device_network_provider() {
        let manufacturer = deviceInfo.cachedInfo.networkProvider
        XCTAssert(manufacturer == "Unknown")
    }

    func test_device_network_total_storage() {
        let manufacturer = deviceInfo.cachedInfo.totalSpace
        XCTAssert(manufacturer == 476282)
    }

    func test_device_network_total_ram() {
        let manufacturer = deviceInfo.cachedInfo.totalRAM
        XCTAssert(manufacturer == 8192)
    }

    func test_device_os_version() {
        let manufacturer = deviceInfo.cachedInfo.osVersion
        XCTAssert(manufacturer == "15.4.0")
    }

    func test_device_name() {
        let manufacturer = deviceInfo.cachedInfo.name
        XCTAssert(manufacturer == "iPhone 13 Pro")
    }

    func test_device_os() {
        let manufacturer = deviceInfo.cachedInfo.name
        XCTAssert(manufacturer == "iPhone 13 Pro")
    }

    func test_device_is_bluetooth_turned_on() {
        let manufacturer = deviceInfo.cachedInfo.isBTOn
        XCTAssert(manufacturer == false)
    }

    func test_device_is_ar_supported() {
        let manufacturer = deviceInfo.cachedInfo.arSupport
        XCTAssert(manufacturer == false)
    }

    func test_device_orientation() {
        let manufacturer = deviceInfo.cachedInfo.deviceOrientation
        XCTAssert(manufacturer == "Portrait")
    }

    func test_device_is_wifi_on() {
        let manufacturer = deviceInfo.cachedInfo.isWIFIConnected
        XCTAssert(manufacturer == true)
    }

    func test_device_device_height() {
        let manufacturer = deviceInfo.cachedInfo.height
        XCTAssert(manufacturer == 844)
    }

    func test_device_device_width() {
        let manufacturer = deviceInfo.cachedInfo.width
        XCTAssert(manufacturer == 390)
    }

    func test_device_device_battery_charged_in_percent() {
        let manufacturer = deviceInfo.cachedInfo.deviceBattery
        XCTAssert(manufacturer == -100)
    }

    func test_device_device_battery_charging() {
        let manufacturer = deviceInfo.cachedInfo.isBatteryCharging
        XCTAssert(manufacturer == false)
    }
}
