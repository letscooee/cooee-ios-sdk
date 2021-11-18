//
//  Transform.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Transform: HandyJSON {

    private var rot: Int?

    public func getRotation() -> Int {
        rot ?? 0
    }
}
