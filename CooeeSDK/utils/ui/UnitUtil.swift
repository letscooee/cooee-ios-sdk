//
// Created by Ashish Gaikwad on 22/10/21.
//

import Foundation
import UIKit

/**
 Utility class to process different units in px, % etc.

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class UnitUtil {
    // MARK: Public

    public static func getScaledPixel(_ value: Float) -> CGFloat {
        return CGFloat(value * scalingFactor)
    }

    public static func setScalingFactor(scalingFactor: Float) {
        UnitUtil.scalingFactor = scalingFactor
    }

    // MARK: Private

    private static var scalingFactor: Float = 1.0
}
