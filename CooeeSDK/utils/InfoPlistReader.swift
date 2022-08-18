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
 - Since: 0.1.0
 */
class InfoPlistReader {
    // MARK: Lifecycle

    init() {
        fetchInfo()
    }

    // MARK: Internal

    static let shared = InfoPlistReader()

    var appID: String = ""

    private func fetchInfo() {
        if let infoPlistPath = Bundle.main.url(forResource: "Info", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)

                if let propList = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    appID = propList["COOEE_APP_ID"] as? String ?? ""
                }
            } catch {
                NSLog("\(Constants.TAG) Fail to read Info.plist: \(error)")
            }
        }
    }

    func getAppID() -> String {
        return self.appID
    }
}
