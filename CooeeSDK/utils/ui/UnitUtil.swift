//
// Created by Ashish Gaikwad on 22/10/21.
//

import Foundation
import UIKit

/**
 Utility class to process different units in px, % etc.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class UnitUtil {
    // MARK: Public

    public static func getScalingFactor() {
        if DISPLAY_WIDTH < DISPLAY_HEIGHT {
            let shortEdge = min(STANDARD_RESOLUTION_WIDTH, STANDARD_RESOLUTION_HEIGHT)
            SCALLING_FACTOR = DISPLAY_WIDTH / shortEdge
        } else {
            let longEdge = max(STANDARD_RESOLUTION_WIDTH, STANDARD_RESOLUTION_HEIGHT)
            SCALLING_FACTOR = DISPLAY_HEIGHT / longEdge
        }
    }

    public static func getScaledPixel(_ value: Float) -> CGFloat {
        getScalingFactor()
        return CGFloat(value * SCALLING_FACTOR)
    }

    public static func isWidthGreatestFactor() -> Bool {
        DISPLAY_WIDTH > DISPLAY_HEIGHT
    }

    // MARK: Internal

    static var STANDARD_RESOLUTION_WIDTH: Float = 1080
    static var STANDARD_RESOLUTION_HEIGHT: Float = 1920

    // MARK: Private

    private static let DISPLAY_WIDTH = Float(CooeeFactory.shared.deviceInfo.getDeviceWidth())
    private static let DISPLAY_HEIGHT = Float(CooeeFactory.shared.deviceInfo.getDeviceHeight())
    private static var SCALLING_FACTOR: Float = 0.0
}
