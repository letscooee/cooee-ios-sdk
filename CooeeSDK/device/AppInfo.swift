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

class AppInfo{
    
    static let shared=AppInfo()
    let cachedInfo=CachedInfo()
    
    struct CachedInfo {
        
        var isDebuging: Bool {
            #if DEBUG
            return true
            #else
            return false
            #endif
        }
        
        var name:String {
            let bundleInfoDict: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
            let appName = bundleInfoDict["CFBundleName"] as! String
            
            return appName
        }
        
        var packageName:String {
            let bundleID = Bundle.main.bundleIdentifier ?? ""
            
            return bundleID
        }
        
        var version: String{
            let appShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let appLongVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
            
            return appShortVersion+"+"+appLongVersion
        }
        
        var lastBuildTime:Date?{
            
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
            print(infoDate)
            return infoDate
            
        }
        
    }
    
    func formatDate(date:Date?)->String{
        guard let rawDate = date else {
            return "Unknown"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        return formatter.string(from: rawDate)
    }
    
    func getAppName()->String{
        return cachedInfo.name
    }
    
    func getAppVersion()->String{
        return cachedInfo.version
    }
    
    func getAppPackage()->String{
        return cachedInfo.packageName
    }
    
    func getBuildTime()->String{
        return formatDate(date: cachedInfo.lastBuildTime)
    }
    
    func isAppDebigging()-> Bool{
        return cachedInfo.isDebuging
    }
    
}
