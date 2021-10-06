//
//  AuthenticationRequestBody.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation

struct AuthenticationRequestBody {
    // MARK: Lifecycle

    init(appID: String, appSecret: String, uuid: String, props: [String: Any]) {
        self.appID = appID
        self.appSecret = appSecret
        self.uuid = uuid
        self.props = props
    }

    // MARK: Internal

    var appID: String
    var appSecret: String
    var uuid: String
    var props: [String: Any]
    var sdk = "IOS"

    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()

        dictionary["appID"] = appID
        dictionary["appSecret"] = appSecret
        dictionary["uuid"] = uuid
        dictionary["props"] = props
        dictionary["sdk"] = sdk

        return dictionary
    }
}
