//
//  DeviceAuthenticationBody.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/09/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct DeviceAuthenticationBody {
    // MARK: Lifecycle

    init(appID: String, uuid: String, props: [String: Any]) {
        self.appID = appID
        self.uuid = uuid
        self.props = props
    }

    // MARK: Internal

    var appID: String
    var uuid: String
    var props: [String: Any]
    var sdk = "IOS"

    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()

        dictionary["appID"] = appID
        dictionary["uuid"] = uuid
        dictionary["props"] = props
        dictionary["sdk"] = sdk

        return dictionary
    }
}
