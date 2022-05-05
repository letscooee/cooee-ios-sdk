//
//  NetworkUtility.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import CoreTelephony
import Foundation
import SystemConfiguration

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
    func isConnectedToWifi() -> Bool {
        guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
            return false
        }

        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)

        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)

        if !isReachable {
            return false
        }

        return !isWWAN
    }

    func getCarrierName() -> String {
        if #available(iOS 13.0, *) {
            let networkInfo = CTTelephonyNetworkInfo()
            let carrier = networkInfo.serviceSubscriberCellularProviders
            let ctCarrier = carrier?.first?.value
            return ctCarrier?.carrierName ?? "Unknown"
        } else {
            return "Unknown"
        }
    }

    func getNetworkType() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrierType = networkInfo.serviceCurrentRadioAccessTechnology

        guard let carrierTypeName = carrierType?.first?.value else {
            return "Unknown"
        }

        var is5G: Bool = false

        // As SDK support iOS 13.0+ versions; And 5G support added in iOS 14.1 hence platform specific code will
        // let us know if network type is 5G or not
        if #available(iOS 14.1, *) {
            if carrierTypeName == CTRadioAccessTechnologyNRNSA || carrierTypeName == CTRadioAccessTechnologyNR {
                is5G = true
            }
        }

        if carrierTypeName == CTRadioAccessTechnologyGPRS || carrierTypeName == CTRadioAccessTechnologyEdge
            || carrierTypeName == CTRadioAccessTechnologyCDMA1x
        {
            return "2G"
        } else if carrierTypeName == CTRadioAccessTechnologyWCDMA || carrierTypeName == CTRadioAccessTechnologyHSDPA
            || carrierTypeName == CTRadioAccessTechnologyHSUPA || carrierTypeName == CTRadioAccessTechnologyCDMAEVDORev0
            || carrierTypeName == CTRadioAccessTechnologyCDMAEVDORevA || carrierTypeName == CTRadioAccessTechnologyCDMAEVDORevB
            || carrierTypeName == CTRadioAccessTechnologyeHRPD
        {
            return "3G"
        } else if carrierTypeName == CTRadioAccessTechnologyLTE {
            return "4G"
        } else if is5G {
            return "5G"
        } else {
            return "Unknown"
        }
    }
}
