//
//  CustomError.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 06/10/21.
//

import Foundation

enum CustomError: String, LocalizedError {
    case PropertyError = "Property name cannot start with 'CE '"

    public var errorDescription: String? {
        self.rawValue
    }
}
