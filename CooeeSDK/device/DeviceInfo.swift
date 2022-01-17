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
            return UIDevice.current.model
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
