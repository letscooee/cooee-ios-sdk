//
//  SDKInfo.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 22/09/21.
//

import Foundation

/**
 Collect all the SDK information at one location

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class SDKInfo {
    struct CachedInfo {
        let sdkVersion = Bundle(identifier: "com.letscooee.CooeeSDK")?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let sdkLongVersion = Bundle(identifier: "com.letscooee.CooeeSDK")?.infoDictionary?["CFBundleVersion"] as? String ?? ""

        var isDebugging: Bool {
            let mode = Bundle(identifier: "com.letscooee.CooeeSDK")?.infoDictionary?["Configuration"] as? String ?? "Debug"
            return (mode.equals("Debug"))
        }
    }

    static let shared = SDKInfo()

    let cachedInfo = CachedInfo()
}
