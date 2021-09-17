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
    
    func putString(key: String, value: String) {
        UserDefaults.standard.set(value forkey: key)
    }

    func getString(key: String) -> String? {
        return UserDefaults.standard.value(forKey: key) as? String
    }

    func putInt(key: String, value: Int) {
        UserDefaults.standard.set(value forkey: key)
    }

    func getInt(key: String) -> Int? {
        return UserDefaults.standard.value(forKey: key) as? Int
    }

    func putBoolean(key: String, value: Bool) {
        UserDefaults.standard.set(value forkey: key)
    }

    func getBoolean(key: String) -> Bool? {
        return UserDefaults.standard.value(forKey: key) as? Bool ?? false
    }
}
