//
//  Transform.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON
import SwiftUI

/**
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct Transform: HandyJSON {
    // MARK: Public

    public func getRotation() -> Angle {
        Angle(degrees: Double(rot ?? 0))
    }

    // MARK: Private

    private var rot: Int? // Rotation in degree
}
