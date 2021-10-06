//
//  SDKInfo.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 22/09/21.
//

import Foundation

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
