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
    // MARK: Lifecycle

    init() {
        bundle = Bundle(for: type(of: self))
        cachedInfo = CachedInfo(bundle: bundle)
    }

    // MARK: Internal

    struct CachedInfo {
        // MARK: Lifecycle

        init(bundle: Bundle) {
            self.bundle = bundle
            sdkVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
            sdkLongVersion = sdkVersion.getVersionNumber()
        }

        // MARK: Internal

        let bundle: Bundle
        let sdkVersion: String
        let sdkLongVersion: String

        var isDebugging: Bool {
            let mode = bundle.infoDictionary?["Configuration"] as? String ?? "Debug"
            return (mode.equals("Debug"))
        }
    }

    static let shared = SDKInfo()

    let bundle: Bundle
    let cachedInfo: CachedInfo
}

extension String {
    /**
     Converts VersionName to verion number

     - returns:Version number String
     */
    func getVersionNumber() -> String {
        let split = components(separatedBy: ".")
        var versionNo = ""

        for value in split {
            versionNo = "\(versionNo)\(String(format: "%02d", Int(value) ?? 0))"
        }

        return versionNo
    }
}
