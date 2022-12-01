// 
// AutoClose.swift
// CooeeSDK
//
// Created by Ashish Gaikwad on 01/12/22.
//

import Foundation
import HandyJSON
import SwiftUI

/**
 Holds auto close properties of InApp
 
 - Author: Ashish Gaikwad
 - Since: 1.4.2
 */
class AutoClose: HandyJSON, CustomDebugStringConvertible {

    var progressBarColour: String?
    var seconds: Int?
    var hideProgress: Bool? = false
    var debugDescription: String {
        """
        AutoClose(progressBarColour: \(String(describing: progressBarColour)), 
        seconds: \(seconds ?? 0), hideProgress: \(hideProgress ?? false))
        """
    }

    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &progressBarColour, name: "c")
        mapper.specify(property: &seconds, name: "sec")
        mapper.specify(property: &hideProgress, name: "v")
    }

    required init() {
    }

    func showTimer() -> Bool {
        if let seconds = seconds, seconds != 0 {
            return true
        }

        return false
    }

    func getColor() -> SwiftUI.Color {
        SwiftUI.Color(hex: progressBarColour ?? "#000000")
    }

}
