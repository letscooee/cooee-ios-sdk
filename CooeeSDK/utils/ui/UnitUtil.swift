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

    private static let DISPLAY_WIDTH: Float = Float(CooeeFactory.shared.deviceInfo.getDeviceWidth())
    private static let DISPLAY_HEIGHT: Float = Float(CooeeFactory.shared.deviceInfo.getDeviceHeight())

    /**
     Use to remove unit character from string and will convert {@link String} to {@link Int}

     - Parameters:
       - valueToConvert: {@link String} value which want to process
       - replaceUnit: it can be "px,%,vh,vw"
     - Returns: Int if everything done else 0
     */
    public static func parseToInt(_ valueToConvert: String, _ replaceUnit: String) -> Int {
        Int(valueToConvert.replacingOccurrences(of: replaceUnit, with: "")) ?? 0
    }

    /**
        Use to remove unit character from string and will convert {@link String} to {@link Float}

        - Parameters:
          - valueToConvert: {@link String} value which want to process
          - replaceUnit: it can be "px,%,vh,vw"
        - Returns: Float if everything done else 0
        */
    public static func parseToFloat(_ valueToConvert: String, _ replaceUnit: String) -> CGFloat {
        CGFloat(Double(valueToConvert.replacingOccurrences(of: replaceUnit, with: "")) ?? 0)
    }

    public static func getCalculatedPixel(_ pixelString: String) -> CGFloat {
        CGFloat(parseToFloat(pixelString, Constants.UNIT_PIXEL));
    }

    public static func getCalculatedValue(_ parentWidth: CGFloat, _  parentHeight: CGFloat, _  value: String) -> CGFloat {
        getCalculatedValue(parentWidth, parentHeight, value, false)
    }

    public static func getCalculatedValue(_ parent: UIView, _ value: String) -> CGFloat {
        getCalculatedValue(parent, value, false)
    }

    public static func getCalculatedValue(_ parent: UIView, _ value: String, _ isHeight: Bool) -> CGFloat {
        getCalculatedValue(parent.frame.width, parent.frame.height, value, isHeight);
    }

    public static func getCalculatedValue(_ parentWidth: CGFloat, _  parentHeight: CGFloat, _  value: String, _  isHeight: Bool) -> CGFloat {

        let value = value.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).lowercased()

        if (!value.contains(Constants.UNIT_PIXEL))
                   && (!value.contains(Constants.UNIT_PERCENT))
                   && (!value.contains(Constants.UNIT_VIEWPORT_HEIGHT))
                   && (!value.contains(Constants.UNIT_VIEWPORT_WIDTH)) {
            return CGFloat(Float(value) ?? 0).pixelsToPoints()
        }

        if (value.contains(Constants.UNIT_PIXEL)) {
            return getCalculatedPixel(value).pixelsToPoints();
            // TODOX: 26/07/21 Consider landscape mode here
            //return webPixels * DISPLAY_HEIGHT / STANDARD_RESOLUTION;

        } else if (value.contains(Constants.UNIT_PERCENT)) {
            if (CooeeFactory.shared.sdkInfo.cachedInfo.isDebugging) {
                print("Parent width: \(parentWidth), height: \(parentHeight)");
            }
            let convertedValue = parseToFloat(value, Constants.UNIT_PERCENT)
            if (isHeight) {
                return CGFloat((convertedValue * parentHeight) / 100);
            } else {
                return CGFloat((convertedValue * parentWidth) / 100);
            }

        } else if (value.contains(Constants.UNIT_VIEWPORT_HEIGHT)) {
            let convertedValue = parseToFloat(value, Constants.UNIT_VIEWPORT_HEIGHT).pixelsToPoints()
            return ((convertedValue * CGFloat(DISPLAY_HEIGHT)) / 100);

        } else if (value.contains(Constants.UNIT_VIEWPORT_WIDTH)) {
            let convertedValue = parseToFloat(value, Constants.UNIT_VIEWPORT_WIDTH).pixelsToPoints()
            return ((convertedValue * CGFloat(DISPLAY_WIDTH)) / 100);
        }

        return 0;
    }
}
