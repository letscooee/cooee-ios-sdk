//
//  CustomError.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 06/10/21.
//

import Foundation

/**
 Custom Error.
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
enum CustomError: String, LocalizedError {
    case PropertyError = "Property name cannot start with 'CE '"
    case EmptyInAppData = "Couldn't render In-App because trigger data is null"
    case emptyData
    case invalidImage
    case notificationFailed = "Fail to render notification"

    // MARK: Public

    public var errorDescription: String? {
        self.rawValue
    }
}
