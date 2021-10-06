//
//  AppInfo.swift
//  CooeeSDK
//
// A utility helper class to provide some information of the device.
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import Foundation
import UIKit

/**
 A utility helper class to provide some common information about the installing/host app.
 - Author: Ashish Gaikwad
 - Since:0.1
 */
class AppInfo {
    struct CachedInfo {
        var isDebugging: Bool {
            #if DEBUG
            return true
            #else
            return false
            #endif
        }

        var name: String {
            let bundleInfoDict: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
            let appName = bundleInfoDict["CFBundleName"] as! String

            return appName
        }

        var packageName: String {
            let bundleID = Bundle.main.bundleIdentifier ?? ""

            return bundleID
        }

        var version: String {
            let appShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let appLongVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""

            return appShortVersion + "+" + appLongVersion
        }

        var lastBuildTime: Date? {
            guard let infoPath = Bundle.main.path(forResource: "Info.plist", ofType: nil) else {
                return nil
            }
            guard let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath) else {
                return nil
            }
            let key = FileAttributeKey(rawValue: "NSFileCreationDate")
            guard let infoDate = infoAttr[key] as? Date else {
                return nil
            }

            return infoDate
        }

        var installDate: Date? {
            let urlToDocumentsFolder: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            return try? FileManager.default.attributesOfItem(atPath: (urlToDocumentsFolder?.path)!)[.creationDate] as? Date
        }
    }

    static let shared = AppInfo()

    let cachedInfo = CachedInfo()

    /**
     Converts Date in String with fixed format
     - parameters:
        - date: Date to be convert in format
     
     - returns:date in String format
     */
    func formatDate(date: Date?) -> String {
        guard let rawDate = date else {
            return "Unknown"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        return formatter.string(from: rawDate)
    }

    /**
     Provides App name
     
     - returns:Device App String
     */
    func getAppName() -> String {
        return cachedInfo.name
    }

    /**
     Provide App Version
     
     - returns:App version in String
     */
    func getAppVersion() -> String {
        return cachedInfo.version
    }

    /**
     Provide App Bundle ID
     
     - returns:App Bundle ID in String
     */
    func getAppPackage() -> String {
        return cachedInfo.packageName
    }

    /**
     Provide App Build Date and TIme
     
     - returns:App Build Date and TIme in String
     */
    func getBuildTime() -> String? {
        if cachedInfo.lastBuildTime == nil {
            return nil
        }
        return DateUtils.formatDateToUTCString(date: cachedInfo.lastBuildTime!)
    }

    func getInstalledDate() -> String? {
        if cachedInfo.installDate == nil {
            return nil
        }
        return DateUtils.formatDateToUTCString(date: cachedInfo.installDate!)
    }

    /**
     Provide if app is debug mode or release mode
     
     - returns:`true` if app is in debug mode
     */
    func isAppDebugging() -> Bool {
        return cachedInfo.isDebugging
    }
}
