//
//  NetworkUtility.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation
import SystemConfiguration
import CoreTelephony
class NetworkUtility {
    static let shared = NetworkUtility()

    func getNetworkType()->String {
        guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
            return "NO INTERNET"
        }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if isReachable {
            if isWWAN {
                let networkInfo = CTTelephonyNetworkInfo()
                let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
                
                guard let carrierTypeName = carrierType?.first?.value else {
                    return "UNKNOWN"
                }
                
                switch carrierTypeName {
                case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                    return "2G"
                case CTRadioAccessTechnologyLTE:
                    return "4G"
                default:
                    return "3G"
                }
            } else {
                return "WIFI"
            }
        } else {
            return "NO INTERNET"
        }
    }
    
    func getCarrierName()->String {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.serviceSubscriberCellularProviders
        let ctCarier = carrier?.first?.value
        return ctCarier?.carrierName ?? "Unknown"
    }
}
