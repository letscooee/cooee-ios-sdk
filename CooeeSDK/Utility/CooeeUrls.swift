//
//  CooeeUrls.swift
//  CooeeiOSSDK
//
//  Created by Surbhi Lath on 25/01/21.
//

import Foundation

struct URLS {
    static let baseURL = "https://api.sdk.letscooee.com"
    static let registerUser = "/v1/user/save/"
    static let trackEvent = "/v1/event/track/"
    static let concludeSession = "/v1/session/conclude"
    static let keepAlive = "/v1/session/keepAlive"
    static let saveFCM = "/v1/user/setFirebaseToken"
    static let updateProfile = "/v1/user/update"
}
