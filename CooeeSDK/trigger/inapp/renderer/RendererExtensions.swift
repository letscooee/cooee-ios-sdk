//
// Created by Ashish Gaikwad on 25/10/21.
//

import Foundation
import SwiftUI
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
        let shapeLayer = CAShapeLayer()
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
        layer.shadowOpacity = Float(elevation / 100)
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
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }

    func addBlurredBackground(style: UIBlurEffect.Style, alpha: CGFloat) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
    }
}

extension Color {
    
    /**
     Create Color from given hex
     - Parameters:
       - hex: colour in hexadecimal string
       - alpha: alpha value to be added in colour
     */
    init(hex: String, alpha: Double = 100) {
        self.init(UIColor(hexString: hex, alpha / 100))
    }
}

public extension View {
    
    /**
     Extension to add multiple properties to the element via if condition

     - Parameters:
       - condition: Any user condition
     - Returns: View to which condition is added
     */
    @ViewBuilder
    internal func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }

    func frame(_ width: CGFloat, _ height: CGFloat) -> some View {
        self.frame(width: width, height: height)
    }

    func width(_ width: CGFloat) -> some View {
        self.frame(width: width)
    }

    func height(_ height: CGFloat) -> some View {
        self.frame(height: height)
    }

    func align(_ height: CGFloat) -> some View {
        self.frame(height: height)
    }

    func fontWithLineHeight(font: UIFont, lineHeight: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: font, lineHeight: lineHeight))
    }
}

public extension Text {
    
    func bold(_ isBold: Bool) -> Text {
        if isBold {
            return self.bold()
        } else {
            return self
        }
    }

    func italic(_ isItalic: Bool) -> Text {
        if isItalic {
            return self.italic()
        } else {
            return self
        }
    }

    func underline(_ addUnderline: Bool) -> Text {
        if addUnderline {
            return self.underline()
        } else {
            return self
        }
    }
}

struct FontWithLineHeight: ViewModifier {
    
    let font: UIFont
    let lineHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .font(SwiftUI.Font(self.font))
            .lineSpacing(self.lineHeight - self.font.lineHeight)
            .padding(.vertical, (self.lineHeight - self.font.lineHeight) / 2)
    }
}

extension UIFont {
    
  static func register(from url: URL) {
    guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
      print("could not get reference to font data provider")
      return
    }
    guard let font = CGFont(fontDataProvider) else {
      print("could not get font from coregraphics")
      return
    }
    var error: Unmanaged<CFError>?
    guard CTFontManagerRegisterGraphicsFont(font, &error) else {
      print("error registering font: \(error.debugDescription)")
      return
    }
  }
}
