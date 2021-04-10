//
//  Device.swift
//  SDKTesting
//
//  Created by Surbhi Lath on 03/02/21.
//

import UIKit

extension UIDevice{
    func totalDiskSpaceInBytes() -> Int64 {
            do {
                guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemSize] as? Int64 else {
                    return 0
                }
                return totalDiskSpaceInBytes/1024/1024
            } catch {
                return 0
            }
        }

        func freeDiskSpaceInBytes() -> Int64 {
            do {
                guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemFreeSize] as? Int64 else {
                    return 0
                }
                return totalDiskSpaceInBytes/1024/1024
            } catch {
                return 0
            }
        }

        func usedDiskSpaceInBytes() -> Int64 {
            return totalDiskSpaceInBytes() - freeDiskSpaceInBytes()
        }

        func totalDiskSpace() -> String {
            let diskSpaceInBytes = totalDiskSpaceInBytes()
            if diskSpaceInBytes > 0 {
                return ByteCountFormatter.string(fromByteCount: diskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
            return "The total disk space on this device is unknown"
        }

        func freeDiskSpace() -> String {
            let freeSpaceInBytes = freeDiskSpaceInBytes()
            if freeSpaceInBytes > 0 {
                return ByteCountFormatter.string(fromByteCount: freeSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
            return "The free disk space on this device is unknown"
        }

        func usedDiskSpace() -> String {
            let usedSpaceInBytes = totalDiskSpaceInBytes() - freeDiskSpaceInBytes()
            if usedSpaceInBytes > 0 {
                return ByteCountFormatter.string(fromByteCount: usedSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
            return "The used disk space on this device is unknown"
        }
    
    func freeRAM() -> Int64{
        var pagesize: vm_size_t = 0

        let host_port: mach_port_t = mach_host_self()
        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        host_page_size(host_port, &pagesize)

        var vm_stat: vm_statistics = vm_statistics_data_t()
        withUnsafeMutablePointer(to: &vm_stat) { (vmStatPointer) -> Void in
            vmStatPointer.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                if (host_statistics(host_port, HOST_VM_INFO, $0, &host_size) != KERN_SUCCESS) {
                    NSLog("Error: Failed to fetch vm statistics")
                }
            }
        }
        /* Stats in bytes */
        let mem_used: Int64 = Int64(vm_stat.active_count +
                vm_stat.inactive_count +
                vm_stat.wire_count) * Int64(pagesize)
        let mem_free: Int64 = Int64(vm_stat.free_count) * Int64(pagesize)
        return mem_free/1024/1024
    }
    
    static let modelName: String = {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }

            func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
                #if os(iOS)
                switch identifier {
                case "iPod5,1":                                 return "iPod touch (5th generation)"
                case "iPod7,1":                                 return "iPod touch (6th generation)"
                case "iPod9,1":                                 return "iPod touch (7th generation)"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
                case "iPhone11,8":                              return "iPhone XR"
                case "iPhone12,1":                              return "iPhone 11"
                case "iPhone12,3":                              return "iPhone 11 Pro"
                case "iPhone12,5":                              return "iPhone 11 Pro Max"
                case "iPhone12,8":                              return "iPhone SE (2nd generation)"
                case "iPhone13,1":                              return "iPhone 12 mini"
                case "iPhone13,2":                              return "iPhone 12"
                case "iPhone13,3":                              return "iPhone 12 Pro"
                case "iPhone13,4":                              return "iPhone 12 Pro Max"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
                case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
                case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
                case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
                case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
                case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
                case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
                case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
                case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
                case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
                case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
                case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
                case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
                case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
                case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
                case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
                case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
                case "AppleTV5,3":                              return "Apple TV"
                case "AppleTV6,2":                              return "Apple TV 4K"
                case "AudioAccessory1,1":                       return "HomePod"
                case "AudioAccessory5,1":                       return "HomePod mini"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
                }
                #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
                }
                #endif
            }

            return mapToDevice(identifier: identifier)
        }()

}
