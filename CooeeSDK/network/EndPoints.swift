//
//  Endpoints.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 20/09/21.
//

import Foundation

struct EndPoints {

    static let BASE_URL = "https://api.sdk.letscooee.com"
    static let registerUser = "/v1/device/validate"
    static let trackEvent = "/v1/event/track/"
    static let concludeSession = "/v1/session/conclude"
    static let keepAlive = "/v1/session/keepAlive"
    static let saveFCM = "/v1/user/setFirebaseToken"
    static let updateProfile = "/v1/user/update"
}
