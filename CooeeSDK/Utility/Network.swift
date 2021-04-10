//
//  Network.swift
//  SDKTesting
//
//  Created by Surbhi Lath on 04/02/21.
//

import Foundation
import SystemConfiguration
import CoreTelephony
class NetworkData {
    static let shared = NetworkData()
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
    
    func getCarrierName()->String{
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        return carrier?.carrierName ?? "Unknown"
    }
}
