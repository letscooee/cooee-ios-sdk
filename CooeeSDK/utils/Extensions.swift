//
// Created by Ashish Gaikwad on 22/10/21.
//

import Foundation
import UIKit

/**
 Extensions for all class

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

public extension CGFloat {
    /**
     Converts pixels to points based on the screen scale. For example, if you
     call CGFloat(1).pixelsToPoints() on an @2x device, this method will return
     0.5.

     - parameter pixels: to be converted into points

     - returns: a points representation of the pixels
     */
    func pixelsToPoints() -> CGFloat {
        return self / UIScreen.main.scale
    }

    /**
     Returns the number of points needed to make a 1 pixel line, based on the
     scale of the device's screen.

     - returns: the number of points needed to make a 1 pixel line
     */
    static func onePixelInPoints() -> CGFloat {
        return CGFloat(1).pixelsToPoints()
    }
}

extension UIView {

    /**
     Create a shape containing dashed border and add it as sub layer in UIView
     - Parameters:
       - colour: Colour to be added to stroke in UIColor
       - width: Width of stroke in Int
       - dashWidth: With of individual dash of stroke in Int
       - dashGap: With of gap between two dash of stroke in Int
       - cornerRadius: Radius of corner in Int
     */
    func addDashedBorder(colour: UIColor, width: Int, dashWidth: Int, dashGap: Int, cornerRadius: Int) {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = colour.cgColor
        shapeLayer.lineWidth = CGFloat(width)
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.cornerRadius = CGFloat(cornerRadius)
        shapeLayer.lineDashPattern = [NSNumber(value: dashWidth), NSNumber(value: dashGap)]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

        self.layer.addSublayer(shapeLayer)
    }
}