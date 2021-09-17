//
//  InfoPlistReader.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 17/09/21.
//

import Foundation

/**
 Utility class which provides reading the info.plist.
 - Author: Ashish Gaikwad
 - Since:0.1
 */
class InfoPlistReader {
    // MARK: Lifecycle

    init() {
        if let infoPlistPath = Bundle.main.url(forResource: "Info", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)

                if let propList = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    appID = propList["CooeeAppID"] as? String ?? ""
                    appSecret = propList["CooeeSecretKey"] as? String ?? ""
                }
            } catch {
                print(error)
            }
        }
    }

    // MARK: Internal

    static let shared = InfoPlistReader()

    var appID: String = ""
    var appSecret: String = ""

    func getAppID() -> String {
        return self.appID
    }

    func getAppSecret() -> String {
        return self.appSecret
    }
}
