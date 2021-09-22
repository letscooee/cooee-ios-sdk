//
//  DeviceInfo.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import ARKit
import Foundation
import UIKit

/**
 A utility helper class to provide some information of the device.
 
 - Author: Ashish Gaikwad
 - Since:0.1
 */
class DeviceInfo {
    struct CashedInfo {
        // TODO: blutute
    
        var manufacture = "Apple"
        // var networkUtility = NetworkUtility.shared
        var deviceBattery = UIDevice.current.batteryLevel * 100
        // var networkProvider = NetworkUtility.shared.getCarrierName()
        // var networkType = NetworkUtility.shared.getNetworkType()
        
        let osVersion = String(ProcessInfo().operatingSystemVersion.majorVersion) + "." + String(ProcessInfo().operatingSystemVersion.minorVersion) + "." + String(ProcessInfo().operatingSystemVersion.patchVersion)
        
        let totalRAM = ProcessInfo.processInfo.physicalMemory/1024/1024
        let availavleRAM = 1234
        let dpi = 1.0

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
            return UIDevice.current.orientation.isLandscape ? "Landscape" : "Potrait"
        }
        
        var deviceModel: String {
            return UIDevice.current.model
        }
        
        var freeSpace: Int64 {
            do {
                guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemFreeSize] as? Int64 else {
                    return 0
                }
                return totalDiskSpaceInBytes
            } catch {
                return 0
            }
        }
        
        var totalSpace: Int64 {
            do {
                guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemSize] as? Int64 else {
                    return 0
                }
                return totalDiskSpaceInBytes
            } catch {
                return 0
            }
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
