//
//  NetworkUtility.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation
import SystemConfiguration
import CoreTelephony

/**
 Utility class to detect network operator and network type.
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class NetworkUtility {

    static let shared = NetworkUtility()

    /**
     Checks the provider by which app is connected to internet
     - Returns: provider by which app is connected (2G/3G/4G/5G/WIFI )
     */
    func getNetworkType() -> String {
        guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
            return "NO INTERNET"
        }

        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)

        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)

        if !isReachable {
            return "NO INTERNET"
        }

        if !isWWAN {
            return "WIFI"
        }

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
    }

    func getCarrierName() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.serviceSubscriberCellularProviders
        let ctCarrier = carrier?.first?.value
        return ctCarrier?.carrierName ?? "Unknown"
    }
}