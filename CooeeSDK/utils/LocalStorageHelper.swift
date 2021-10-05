//
//  LocalStorageHelper.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/09/21.
//

import Foundation

/**
 LocalStorageHelper is used to store local shared preference data
 - Author: Ashish Gaikwad
 - Since:0.1
 */
class LocalStorageHelper {
    
    static func putString(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func getString(key: String) -> String? {
        return UserDefaults.standard.value(forKey: key) as? String
    }

    static func putInt(key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func getInt(key: String, defaultValue: Int?) -> Int {
        return UserDefaults.standard.value(forKey: key) as! Int
    }

    static func putBoolean(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func getBoolean(key: String, defaultValue:Bool?) -> Bool? {
        return UserDefaults.standard.value(forKey: key) as? Bool ?? defaultValue
    }
    
    static func putLong(key: String, value: Int64?) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func getLong(key: String, defaultValue: Int64) -> Int64 {
        return UserDefaults.standard.value(forKey: key) as? Int64 ?? defaultValue
    }
}
