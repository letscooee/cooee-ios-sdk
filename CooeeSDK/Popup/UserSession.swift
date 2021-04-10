//
//  UserSession.swift
//  CooeeiOSSDK
//
//  Created by Surbhi Lath on 28/01/21.
//

import Foundation

struct UserSession {
    static let userID = "user_id"
    static let userAccessToken = "whole_saler_id"
    static var fcmTokenKey = "fcmToken"
    static var stringSessionID = "session_id"
    static var udidString = "UDID"
    static var triggerDataString = "triggerData"
    static func save (userToken: String){
        UserDefaults.standard.set(userToken, forKey: userID)
    }
    
    static func getUserToken()-> String? {
        return UserDefaults.standard.value(forKey: userID) as? String
    }
    
    static func save (sessionID: String){
        UserDefaults.standard.set(sessionID, forKey: stringSessionID)
    }
    
    static func getSessionID()-> String? {
        return UserDefaults.standard.value(forKey: stringSessionID) as? String
    }
    static func save (udid: String){
        UserDefaults.standard.set(udid, forKey: udidString)
    }
    
    static func getudid()-> String? {
        return UserDefaults.standard.value(forKey: udidString) as? String
    }
    
    static func save (triggerData: [TriggerDataModel]){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(triggerData), forKey:triggerDataString)
    }
    
    static func getTriggerData()-> [TriggerDataModel] {
        var list = [TriggerDataModel]()
        if let data = UserDefaults.standard.value(forKey:triggerDataString) as? Data {
            list = try! PropertyListDecoder().decode([TriggerDataModel].self, from: data)
        }
        return list
    }
}



