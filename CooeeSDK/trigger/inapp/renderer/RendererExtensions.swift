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
        blurView.layer.cornerRadius = 15
        blurView.clipsToBounds = true
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
       - transform: complete listener
     - Returns: View to which condition is added
     */
    @ViewBuilder
    internal func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
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
            NSLog("Could not get reference to font data provider")
            return
        }
        guard let font = CGFont(fontDataProvider) else {
            NSLog("Could not get font from coregraphics")
            return
        }
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            NSLog("Error registering font: \(error.debugDescription)")
            return
        }
    }
}

extension UIImage {

    /**
     Change the size of image present UIImage

     - Parameter sizeChange: custom size of image in CGSize
     - Returns: resized UIImage
     */
    func imageResize(sizeChange: CGSize) -> UIImage {
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }

    /**
     Check if image has multiple frames. If multiple frames are present then that image is
     considered as GIF otherwise normal image.

     - Parameter data: image in Data
     - Parameter url: image url
     - Returns: optional UIImage
     */
    public class func gif(data: Data, url: String) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            NSLog("Load GIF/Image: Source for the image does not exist")
            return nil
        }

        let count = CGImageSourceGetCount(source)
        if count > 1 {
            return UIImage.animatedImageWithSource(source)
        } else if count == 1 {
            return UIImage(data: data)
        } else {
            CooeeFactory.shared.sentryHelper.capture(message: "Fail to load image with url:\(url)")
            return nil
        }
    }

    /**
     Loads Image from assets present in app
     This method is not used anywhere

     - Parameters:
       - asset: asset name
       - url: image url
     - Returns: optional UIImage
     */
    @available(iOS 9.0, *)
    public class func gif(asset: String, url: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            NSLog("Load GIF/Image: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }

        return gif(data: dataAsset.data, url: url)
    }

    /**
     Evaluate the display delay for particular frame

     - Parameters:
       - index: position of the frame to whom delay to be added
       - source: source ig GIF image as CGSourceImage
     - Returns: double value how much delay should be added to the particular frame
     */
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties,
                        Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
                to: AnyObject.self
        )
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!

            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }

    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    /**
     Generate animated instance if the UIImage from the given source.
     - Parameter source: CGImageSource with will contain all GIF frames
     - Returns: animated UIImage
     */
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                    source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
        }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        let animation = UIImage.animatedImage(with: frames,
                duration: Double(duration) / 1000.0)
        return animation
    }
}
