//
//  HttpCalls.swift
//  CooeeSDK
//
//  Created by Surbhi Lath on 27/03/21.
//

import Foundation

public class HttpCalls: NSObject{
    
    static let networkService = WService.shared
    
    static func callEventTrack(with params: Dictionary<String, Any>, completionHandler: @escaping(_ result: DataTriggered?) -> ()){
        let token = UserSession.getUserToken() ?? ""

        networkService.getResponse(fromURL: URLS.trackEvent, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: TrackEventResponse) in
            if let data = result.triggerData{
                completionHandler(data)
            }
        }
    }
    
    static func callConcludeSession(with duration: Int){
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        let params = ["duration": duration, "sessionID": sessionID] as [String : Any]

        networkService.getResponse(fromURL: URLS.concludeSession, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: TrackEventResponse) in
            
        }
    }
    
     @objc static func callKeepAlive(){
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        let params = ["sessionID": sessionID] as [String : Any]

        networkService.getResponse(fromURL: URLS.keepAlive, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: DefaultRespoonse) in
            
        }
    }
    
   static func callFirebaseToken(fToken: String){
        let params = ["firebaseToken": fToken] as [String : Any]
        let token = UserSession.getUserToken() ?? ""

        networkService.getResponse(fromURL: URLS.saveFCM, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: DefaultRespoonse) in
            
        }
    }
    
    static func callForUpdateProfile(withProperties: [String: String]?,  andData: [String:String]?){
        
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        var propeties = [String: String]()
        if let userProperties = withProperties{
            propeties = userProperties
        }
        var data = [String: String]()
        if let userData = andData{
            data = userData
        }
        let params = ["sessionID": sessionID, "userProperties": propeties, "userData": data] as [String : Any]
        
        networkService.getResponse(fromURL: URLS.updateProfile, method: .PUT, params: params, header: ["x-sdk-token":token]) { (result: DefaultRespoonse) in
        }
    }
}
