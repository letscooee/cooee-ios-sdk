//
//  DeviceInfo.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import ARKit
import CoreBluetooth
import Foundation
import UIKit

/**
 A utility helper class to provide some information of the device.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class DeviceInfo {

    struct CashedInfo {

        var manufacture = "Apple"
        var networkUtility = NetworkUtility.shared
        var networkProvider = NetworkUtility.shared.getCarrierName()
        var networkType = NetworkUtility.shared.getNetworkType()
        var isWIFIConnected = (NetworkUtility.shared.getNetworkType() == "WIFI") ? true : false

        let osVersion = String(ProcessInfo().operatingSystemVersion.majorVersion) + "." + String(ProcessInfo().operatingSystemVersion.minorVersion) + "." + String(ProcessInfo().operatingSystemVersion.patchVersion)

        let totalRAM = ProcessInfo.processInfo.physicalMemory / 1024 / 1024
        let dpi = 1.0

        var deviceBattery: Float {
            UIDevice.current.isBatteryMonitoringEnabled = true
            return UIDevice.current.batteryLevel * 100
        }

        var isBatteryCharging: Bool {
            UIDevice.current.isBatteryMonitoringEnabled = true

            return UIDevice.current.batteryState == .charging
        }

        var availableRAM: Int64 {
            var pagesize: vm_size_t = 0

            let host_port: mach_port_t = mach_host_self()
            var host_size = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
            host_page_size(host_port, &pagesize)

            var vm_stat: vm_statistics = vm_statistics_data_t()
            withUnsafeMutablePointer(to: &vm_stat) { vmStatPointer -> Void in
                vmStatPointer.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                    if host_statistics(host_port, HOST_VM_INFO, $0, &host_size) != KERN_SUCCESS {
                        NSLog("Error: Failed to fetch vm statistics")
                    }
                }
            }
            /* Stats in bytes */
            _ = Int64(vm_stat.active_count +
                    vm_stat.inactive_count +
                    vm_stat.wire_count) * Int64(pagesize)
            let mem_free = Int64(vm_stat.free_count) * Int64(pagesize)
            return mem_free / 1024 / 1024
        }

        var name: String {
            return UIDevice.current.name
        }

        var width: CGFloat {
            return UIScreen.main.bounds.width
        }

        var height: CGFloat {
            return UIScreen.main.bounds.height
        }

        var arSupport: Bool {
            return ARConfiguration.isSupported
        }

        var deviceOrientation: String {
            return UIDevice.current.orientation.isLandscape ? "Landscape" : "Portrait"
        }

        var deviceModel: String {
            return UIDevice.modelName
        }

        var freeSpace: Int64 {
            do {
                guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemFreeSize] as? Int64 else {
                    return 0
                }
                return totalDiskSpaceInBytes / 1024 / 1024
            } catch {
                return 0
            }
        }

        var totalSpace: Int64 {
            do {
                guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemSize] as? Int64 else {
                    return 0
                }
                return totalDiskSpaceInBytes / 1024 / 1024
            } catch {
                return 0
            }
        }

        var isBTOn: Bool {
            let options = [
                CBCentralManagerOptionShowPowerAlertKey: NSNumber(value: false)
            ]
            let centralManager = CBCentralManager(delegate: nil, queue: nil, options: options)
            if centralManager.state == .poweredOn {
                return true
            }
            return false
        }
    }

    static let shared = DeviceInfo()

    let cachedInfo = CashedInfo()

    /**
      Get the name of the device.

      - returns: Device name in `String`
     */
    func getDeviceName() -> String {
        return cachedInfo.name
    }

    /**
     Provide device screen's width

     - returns: `CGFloat` Value
     */
    func getDeviceWidth() -> CGFloat {
        return cachedInfo.width
    }

    /**
     Provide device screen's height

     - returns: `CGFloat` Value
     */
    func getDeviceHeight() -> CGFloat {
        return cachedInfo.height
    }
}

import SystemConfiguration

public extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        let deviceMapping = ["i386": "iPhone Simulator",
         "x86_64": "iPhone Simulator",
         "arm64": "iPhone Simulator",
         "iPhone1,1": "iPhone",
         "iPhone1,2": "iPhone 3G",
         "iPhone2,1": "iPhone 3GS",
         "iPhone3,1": "iPhone 4",
         "iPhone3,2": "iPhone 4 GSM Rev A",
         "iPhone3,3": "iPhone 4 CDMA",
         "iPhone4,1": "iPhone 4S",
         "iPhone5,1": "iPhone 5 (GSM)",
         "iPhone5,2": "iPhone 5 (GSM+CDMA)",
         "iPhone5,3": "iPhone 5C (GSM)",
         "iPhone5,4": "iPhone 5C (Global)",
         "iPhone6,1": "iPhone 5S (GSM)",
         "iPhone6,2": "iPhone 5S (Global)",
         "iPhone7,1": "iPhone 6 Plus",
         "iPhone7,2": "iPhone 6",
         "iPhone8,1": "iPhone 6s",
         "iPhone8,2": "iPhone 6s Plus",
         "iPhone8,4": "iPhone SE (GSM)",
         "iPhone9,1": "iPhone 7",
         "iPhone9,2": "iPhone 7 Plus",
         "iPhone9,3": "iPhone 7",
         "iPhone9,4": "iPhone 7 Plus",
         "iPhone10,1": "iPhone 8",
         "iPhone10,2": "iPhone 8 Plus",
         "iPhone10,3": "iPhone X Global",
         "iPhone10,4": "iPhone 8",
         "iPhone10,5": "iPhone 8 Plus",
         "iPhone10,6": "iPhone X GSM",
         "iPhone11,2": "iPhone XS",
         "iPhone11,4": "iPhone XS Max",
         "iPhone11,6": "iPhone XS Max Global",
         "iPhone11,8": "iPhone XR",
         "iPhone12,1": "iPhone 11",
         "iPhone12,3": "iPhone 11 Pro",
         "iPhone12,5": "iPhone 11 Pro Max",
         "iPhone12,8": "iPhone SE 2nd Gen",
         "iPhone13,1": "iPhone 12 Mini",
         "iPhone13,2": "iPhone 12",
         "iPhone13,3": "iPhone 12 Pro",
         "iPhone13,4": "iPhone 12 Pro Max",
         "iPhone14,2": "iPhone 13 Pro",
         "iPhone14,3": "iPhone 13 Pro Max",
         "iPhone14,4": "iPhone 13 Mini",
         "iPhone14,5": "iPhone 13",
         "iPod1,1": "1st Gen iPod",
         "iPod2,1": "2nd Gen iPod",
         "iPod3,1": "3rd Gen iPod",
         "iPod4,1": "4th Gen iPod",
         "iPod5,1": "5th Gen iPod",
         "iPod7,1": "6th Gen iPod",
         "iPod9,1": "7th Gen iPod",
         "iPad1,1": "iPad",
         "iPad1,2": "iPad 3G",
         "iPad2,1": "2nd Gen iPad",
         "iPad2,2": "2nd Gen iPad GSM",
         "iPad2,3": "2nd Gen iPad CDMA",
         "iPad2,4": "2nd Gen iPad New Revision",
         "iPad3,1": "3rd Gen iPad",
         "iPad3,2": "3rd Gen iPad CDMA",
         "iPad3,3": "3rd Gen iPad GSM",
         "iPad2,5": "iPad mini",
         "iPad2,6": "iPad mini GSM+LTE",
         "iPad2,7": "iPad mini CDMA+LTE",
         "iPad3,4": "4th Gen iPad",
         "iPad3,5": "4th Gen iPad GSM+LTE",
         "iPad3,6": "4th Gen iPad CDMA+LTE",
         "iPad4,1": "iPad Air (WiFi)",
         "iPad4,2": "iPad Air (GSM+CDMA)",
         "iPad4,3": "1st Gen iPad Air (China)",
         "iPad4,4": "iPad mini Retina (WiFi)",
         "iPad4,5": "iPad mini Retina (GSM+CDMA)",
         "iPad4,6": "iPad mini Retina (China)",
         "iPad4,7": "iPad mini 3 (WiFi)",
         "iPad4,8": "iPad mini 3 (GSM+CDMA)",
         "iPad4,9": "iPad Mini 3 (China)",
         "iPad5,1": "iPad mini 4 (WiFi)",
         "iPad5,2": "4th Gen iPad mini (WiFi+Cellular)",
         "iPad5,3": "iPad Air 2 (WiFi)",
         "iPad5,4": "iPad Air 2 (Cellular)",
         "iPad6,3": "iPad Pro (9.7 inch, WiFi)",
         "iPad6,4": "iPad Pro (9.7 inch, WiFi+LTE)",
         "iPad6,7": "iPad Pro (12.9 inch, WiFi)",
         "iPad6,8": "iPad Pro (12.9 inch, WiFi+LTE)",
         "iPad6,11": "iPad (2017)",
         "iPad6,12": "iPad (2017)",
         "iPad7,1": "iPad Pro 2nd Gen (WiFi)",
         "iPad7,2": "iPad Pro 2nd Gen (WiFi+Cellular)",
         "iPad7,3": "iPad Pro 10.5-inch",
         "iPad7,4": "iPad Pro 10.5-inch",
         "iPad7,5": "iPad 6th Gen (WiFi)",
         "iPad7,6": "iPad 6th Gen (WiFi+Cellular)",
         "iPad7,11": "iPad 7th Gen 10.2-inch (WiFi)",
         "iPad7,12": "iPad 7th Gen 10.2-inch (WiFi+Cellular)",
         "iPad8,1": "iPad Pro 11 inch 3rd Gen (WiFi)",
         "iPad8,2": "iPad Pro 11 inch 3rd Gen (1TB, WiFi)",
         "iPad8,3": "iPad Pro 11 inch 3rd Gen (WiFi+Cellular)",
         "iPad8,4": "iPad Pro 11 inch 3rd Gen (1TB, WiFi+Cellular)",
         "iPad8,5": "iPad Pro 12.9 inch 3rd Gen (WiFi)",
         "iPad8,6": "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi)",
         "iPad8,7": "iPad Pro 12.9 inch 3rd Gen (WiFi+Cellular)",
         "iPad8,8": "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi+Cellular)",
         "iPad8,9": "iPad Pro 11 inch 4th Gen (WiFi)",
         "iPad8,10": "iPad Pro 11 inch 4th Gen (WiFi+Cellular)",
         "iPad8,11": "iPad Pro 12.9 inch 4th Gen (WiFi)",
         "iPad8,12": "iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)",
         "iPad11,1": "iPad mini 5th Gen (WiFi)",
         "iPad11,2": "iPad mini 5th Gen",
         "iPad11,3": "iPad Air 3rd Gen (WiFi)",
         "iPad11,4": "iPad Air 3rd Gen",
         "iPad11,6": "iPad 8th Gen (WiFi)",
         "iPad11,7": "iPad 8th Gen (WiFi+Cellular)",
         "iPad13,1": "iPad air 4th Gen (WiFi)",
         "iPad13,2": "iPad air 4th Gen (WiFi+Cellular)",
         "iPad13,4": "iPad Pro 11 inch 3rd Gen",
         "iPad13,5": "iPad Pro 11 inch 3rd Gen",
         "iPad13,6": "iPad Pro 11 inch 3rd Gen",
         "iPad13,7": "iPad Pro 11 inch 3rd Gen",
         "iPad13,8": "iPad Pro 12.9 inch 5th Gen",
         "iPad13,9": "iPad Pro 12.9 inch 5th Gen",
         "iPad13,10": "iPad Pro 12.9 inch 5th Gen",
         "iPad13,11": "iPad Pro 12.9 inch 5th Gen"]
        return deviceMapping[identifier] ?? identifier
    }()
}
