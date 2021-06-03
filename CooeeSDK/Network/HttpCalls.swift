//
//  HttpCalls.swift
//  CooeeSDK
//
//  Created by Surbhi Lath on 27/03/21.
//

import Foundation
import Network
public class HttpCalls: NSObject{
    
    static let networkService = WService.shared
    let monitor = NWPathMonitor()
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
    
    static func callForUpdateProfile(withProperties: [String: Any]?,  andData: [String:Any]?){
        
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        var propeties = [String: Any]()
        if let userProperties = withProperties{
            propeties = userProperties
        }
        var data = [String: Any]()
        if let userData = andData{
            data = userData
        }
        let params = ["sessionID": sessionID, "userProperties": propeties, "userData": data] as [String : Any]
        
        networkService.getResponse(fromURL: URLS.updateProfile, method: .PUT, params: params, header: ["x-sdk-token":token]) { (result: DefaultRespoonse) in
        }
    }
}

class SendEvent: AbstractOperation{
    var params: [String: Any]?
    let networkService = WService.shared
    var actionBlock: (()->Void)? = nil
    
    override open func main() {
            if isCancelled {
                print("cancelled send event")
                finish()
                return
            }
        let token = UserSession.getUserToken() ?? ""
        if var params = params{
            params["sessionID"] = UserSession.getSessionID() ?? ""
            networkService.getResponse(fromURL: URLS.trackEvent, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: TrackEventResponse) in
                self.finish()
                if result.triggerData != nil{
                    self.actionBlock?()
                }
            }
        }
    }
}

class SendUserProperties: AbstractOperation{
    
    
    var propeties: [String: Any]?
    var data: [String: Any]?
    let networkService = WService.shared
    override open func main() {
        if isCancelled {
            print("cancelled updateProps")
            finish()
            return
        }
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        let params = ["sessionID": sessionID, "userProperties": propeties ?? [:], "userData": data ?? [:]] as [String : Any]
        networkService.getResponse(fromURL: URLS.updateProfile, method: .PUT, params: params, header: ["x-sdk-token":token]) { (result: TrackEventResponse) in
            self.finish()
        }
    }
}

class KeepAlive: AbstractOperation{
    let networkService = WService.shared
    
    
    override open func main() {
        if isCancelled {
            finish()
            return
        }
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        let params = ["sessionID": sessionID] as [String : Any]
        networkService.getResponse(fromURL: URLS.keepAlive, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: DefaultRespoonse) in
            self.finish()
        }
    }
}

class ConcludeSession: AbstractOperation{
    let networkService = WService.shared
    var duration = 0
    
    override open func main() {
        if isCancelled {
            finish()
            return
        }
        let sessionID = UserSession.getSessionID() ?? ""
        let token = UserSession.getUserToken() ?? ""
        let params = ["duration": duration, "sessionID": sessionID] as [String : Any]
        networkService.getResponse(fromURL: URLS.concludeSession, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: TrackEventResponse) in
            self.finish()
        }
    }
}
class RegisterUser: AbstractOperation{
    var sdkVersion = ""
    var osVersion = ""
    var appVersion = ""
    
    override open func main() {
        if isCancelled {
            finish()
            return
        }
        
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            let applicationID = nsDictionary?["CooeeAppID"] as? String ?? ""
            let applicationSecretKey = nsDictionary?["CooeeSecretKey"] as? String ?? ""
            let deviceIOSData = DeviceData(os: "IOS", cooeeSdkVersion: "\(sdkVersion)", appVersion: appVersion, osVersion: osVersion)
            let registerUserData = RegisterUserDataModel(id: applicationID, secretKey: applicationSecretKey, deviceData: deviceIOSData)
            
            WService.shared.getResponse(fromURL: URLS.registerUser, method: .POST, params: registerUserData.dictionary, header: [:]) { (result: RegisterUserResponse) in
                if let token = result.sdkToken{
                    UserSession.save(userToken: token)
                }
                if let sessionID = result.sessionID{
                    UserSession.save(sessionID: sessionID)
                }
                
                if let udid = result.id{
                    UserSession.save(udid: udid)
                }
                self.finish()
                
            }
        }
        
    }
    
}

class UpdateFirebaseToken: AbstractOperation{
    let networkService = WService.shared
    var fcmToken = ""
    
    override open func main() {
        if isCancelled {
            finish()
            return
        }
       let token = UserSession.getUserToken() ?? ""
        let params = ["firebaseToken": fcmToken] as [String : Any]
        networkService.getResponse(fromURL: URLS.saveFCM, method: .POST, params: params, header: ["x-sdk-token":token]) { (result: TrackEventResponse) in
            self.finish()
        }
    }
}
