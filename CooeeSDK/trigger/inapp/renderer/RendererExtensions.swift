//
// Created by Ashish Gaikwad on 25/10/21.
//

import Foundation
import UIKit

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
    func addDashedBorder(colour: UIColor, width: CGFloat, dashWidth: CGFloat, dashGap: CGFloat, cornerRadius: CGFloat) {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = colour.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.cornerRadius = cornerRadius
        shapeLayer.lineDashPattern = [NSNumber(value: dashWidth), NSNumber(value: dashGap)]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

        self.layer.addSublayer(shapeLayer)
    }

    /**
     Add shadow to the element

     - Parameters:
       - elevation: Shadow density in Int
       - colour: Shadow color in UIColor
     */
    func dropShadow(elevation: Int, colour: UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = colour.cgColor

        // shadow opacity can be applied between 0 and 1
        layer.shadowOpacity = Float((elevation / 100))
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    /**
     Rotate a view by specified degrees

     - parameter angle: angle in degrees
     */
    func rotate(angle: Int) {
        let radians = CGFloat(angle) / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }
}