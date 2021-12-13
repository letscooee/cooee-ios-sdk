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

    static func getBoolean(key: String, defaultValue: Bool?) -> Bool? {
        return UserDefaults.standard.value(forKey: key) as? Bool ?? defaultValue
    }

    static func putLong(key: String, value: Int64?) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func getLong(key: String, defaultValue: Int64) -> Int64 {
        return UserDefaults.standard.value(forKey: key) as? Int64 ?? defaultValue
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
        UserDefaults.standard.set(nil, forKey: key)
    }
}
