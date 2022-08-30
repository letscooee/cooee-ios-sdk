//
//  LocalStorageHelper.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/09/21.
//

import Foundation
import HandyJSON

/**
 LocalStorageHelper is used to store local shared preference data

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class LocalStorageHelper {

    private static var bundleId: String {
        return "com.letscooee.\(Bundle.main.object(forInfoDictionaryKey: "COOEE_APP_ID") ?? "")"
    }

    static func putString(key: String, value: String) {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        userDefault?.set(value, forKey: key)
    }

    static func getString(key: String) -> String? {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        return userDefault?.value(forKey: key) as? String
    }

    static func putInt(key: String, value: Int) {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        userDefault?.set(value, forKey: key)
    }

    static func getInt(key: String, defaultValue: Int?) -> Int {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        return userDefault?.value(forKey: key) as? Int ?? 0
    }

    static func putBoolean(key: String, value: Bool) {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        userDefault?.set(value, forKey: key)
    }

    static func getBoolean(key: String, defaultValue: Bool?) -> Bool? {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        return userDefault?.value(forKey: key) as? Bool ?? defaultValue
    }

    static func putLong(key: String, value: Int64?) {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        userDefault?.set(value, forKey: key)
    }

    static func getLong(key: String, defaultValue: Int64) -> Int64 {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        return userDefault?.value(forKey: key) as? Int64 ?? defaultValue
    }

    static func getTypedArray<T: Codable>(key: String, clazz: T.Type) -> [T] {
        if let rawString = getString(key: key) {
            var arr: [T]?

            do {
                arr = try JSONDecoder().decode([T].self, from: rawString.data(using: .utf8)!)
            } catch {
            }

            return arr ?? [T]()
        } else {
            return [T]()
        }
    }

    static func putTypedArray<T: HandyJSON>(key: String, array: [T]) {
        putString(key: key, value: array.toJSONString()!)
    }

    static func putTypedClass<T: HandyJSON>(key: String, data: T) {

        putString(key: key, value: data.toJSONString()!)
    }

    static func getTypedClass<T: Codable>(key: String, clazz: T.Type) -> T? {
        if let rawString = getString(key: key) {
            var arr: T?

            do {
                arr = try JSONDecoder().decode(T.self, from: rawString.data(using: .utf8)!)
            } catch {
            }
            return arr
        } else {
            return nil
        }
    }

    static func remove(key: String) {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        userDefault?.set(nil, forKey: key)
    }

    static func getDictionary(_ key: String, defaultValue: [String: Any]?) -> [String: Any]? {
        let rawString = getString(key: key)
        if rawString == nil {
            return nil
        }

        return rawString!.convertToDictionary()
    }

    static func putDictionary(_ data: [String: Any], for key: String) {
        putString(key: key, value: String(data: data.percentEncoded()!, encoding: .utf8)!)
    }

    /**
     This method is used to store Date in local storage

     - Parameters:
       - key: key to store data
       - value: Date to store
     */
    static func putDate(key: String, value: Date) {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        userDefault?.set(value.timeIntervalSince1970, forKey: key)
    }

    /**
     This method is used to get Date from local storage

     - Parameters:
       - key: key to get data
       - defaultValue: default value if key is not found

     - Returns: Date value if key is found, otherwise default value
     */
    static func getDate(key: String, defaultValue: Date?) -> Date? {
        let userDefault = UserDefaults(suiteName: "group.\(bundleId)")
        
        if let sharedTime = userDefault?.value(forKey: key) as? Double {
            return Date(timeIntervalSince1970: sharedTime)
        }
        
        return defaultValue
    }
}
