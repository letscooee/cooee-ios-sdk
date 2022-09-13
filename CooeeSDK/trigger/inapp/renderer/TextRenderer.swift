//
// Created by Ashish Gaikwad on 27/10/21.
//

import SwiftUI
import UIKit

/**
 Renders a TextElement with its all base property and text properties

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
struct TextRenderer: View {
    // MARK: Lifecycle

    init(textElement: TextElement) {
        self.parentTextElement = textElement
    }

    // MARK: Internal

    let parentTextElement: TextElement
    @State var height: CGFloat = .zero

    var body: some View {
        CustomTextRenderer(textElement: parentTextElement, dynamicHeight: $height)
                .frame(width: parentTextElement.getCalculatedWidth(), height: height)
    }
}

/**
 Custom Text Designer which create text view with the help of UIKit

 - Author: Ashish Gaikwad
 - Since: 1.3.17
 */
struct CustomTextRenderer: UIViewRepresentable {
    var textElement: TextElement
    // var text: String
    @Binding var dynamicHeight: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        // textView.delegate = context.coordinator
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        textView.isEditable = false
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let attributedString = NSMutableAttributedString(
                string: ""
        )

        appendParts(attributedString)

        let textAlignment = textElement.getNSTextAlignment()
        uiView.attributedText = attributedString
        uiView.textAlignment = textAlignment

        processBackground(uiView)
        processPaddingAndBorder(uiView)

        DispatchQueue.main.async {
            dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
            // uiView.layer.sublayers?[0].frame = CGRect(x: 0, y: 0, width: uiView.bounds.width, height: dynamicHeight)
            uiView.customHeight = dynamicHeight
        }

        // uiView.rotate(angle: 3)
        // image.frame = uiView.frame
        // uiView.text = text
    }

    func appendParts(_ mutableString: NSMutableAttributedString) {
        for index in 0..<(textElement.prs?.count ?? 0) {
            let part = textElement.prs![index]
            var partText = part.getPartText()
            if textElement.prs!.count - 1 == index {
                partText = Character(extendedGraphemeClusterLiteral: Array(partText)[partText.count - 1]).isNewline ?
                        String(partText.dropLast()) : partText
            }

            let string = NSMutableAttributedString(
                    string: partText,
                    attributes: getAttibutes(part)
            )

            string.beginEditing()

            let font = textElement.getUIFont(for: part)
            // attributes.updateValue(font, forKey: .font)
            if part.isBold(), part.isItalic(), let descriptor = font.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
                let systemFontBoldAndItalic = UIFont(descriptor: descriptor, size: font.pointSize)
                string.addAttributes([.font: systemFontBoldAndItalic], range: NSRange(location: 0, length: string.length))
            } else if part.isBold(), let descriptor = font.fontDescriptor.withSymbolicTraits([.traitBold]) {
                let systemFontBold = UIFont(descriptor: descriptor, size: font.pointSize)
                string.addAttributes([.font: systemFontBold], range: NSRange(location: 0, length: string.length))
            } else if part.isItalic(), let descriptor = font.fontDescriptor.withSymbolicTraits([.traitItalic]) {
                let systemFontItalic = UIFont(descriptor: descriptor, size: font.pointSize)
                string.addAttributes([.font: systemFontItalic], range: NSRange(location: 0, length: string.length))
            } else {
                string.addAttributes([.font: font], range: NSRange(location: 0, length: string.length))
            }

            string.endEditing()

            mutableString.append(
                    string
            )
        }
    }

    func getAttibutes(_ part: PartElement) -> [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key: Any]()

        let textColour: UIColor = part.getUIPartColour() ?? textElement.getUIColour() ?? UIColor(hexString: "#000000")
        attributes.updateValue(textColour, forKey: .foregroundColor)

        if part.addUnderLine() {
            attributes.updateValue(NSUnderlineStyle.single.rawValue, forKey: .underlineStyle)
        }

        if part.addStrikeThrough() {
            attributes.updateValue(NSUnderlineStyle.single.rawValue, forKey: .strikethroughStyle)
        }

        return attributes
    }

    func processBackground(_ uiView: UITextView) {
        guard let background = textElement.getBackground() else {
            return
        }

        if let solid = background.s {
            addBackgroundColour(solid, on: uiView)
        }
    }

    func addBackgroundColour(_ colour: Colour, on view: UITextView) {
        if colour.g == nil {
            view.backgroundColor = colour.getColour()
        } else {
            view.setGradient(colour.g!)
        }
    }

    func processPaddingAndBorder(_ view: UITextView) {
        var paddingLeft = 0.0, paddingRight = 0.0, paddingTop = 0.0, paddingBottom = 0.0

        if let spc = textElement.spc {
            paddingLeft = spc.getPaddingLeft()
            paddingRight = spc.getPaddingRight()
            paddingTop = spc.getPaddingTop()
            paddingBottom = spc.getPaddingBottom()
        }

        guard let border = textElement.br else {
            view.textContainerInset = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
            return
        }

        let borderWidth = border.getWidth()
        view.textContainerInset = UIEdgeInsets(top: paddingTop + borderWidth, left: paddingLeft + borderWidth, bottom: paddingBottom + borderWidth, right: paddingRight + borderWidth)
        view.layer.cornerRadius = border.getRadius()

        if border.getStyle() == .SOLID {
            view.layer.cornerRadius = border.getRadius()
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = border.getColour()?.cgColor ?? UIColor.black.cgColor
        } else {
            view.setDashBorder(border)
        }
    }
}

extension UITextView {
    @IBInspectable var customHeight: CGFloat {
        set {
            layer.sublayers?.forEach { subLayer in
                if subLayer.isKind(of: CAShapeLayer.self) {
                    (subLayer as! CAShapeLayer).path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
                }
                subLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: newValue)
            }
        }

        get {
            return bounds.height
        }
    }

    func setGradient(_ grad: Gradient) {
        let colourList = grad.getColors()
        if colourList.isEmpty {
            return
        }

        let gradient = CAGradientLayer()

        gradient.colors = colourList

        // Type of gradient (Currently supporting only LINEAR i.e axial)
        // gradient.type = .axial

        /*
         Calculate start and end points for given ``angle``
         Adding 90 in ``angle`` to make similar angle with Android
         */
        let angle = Double(grad.ang ?? 0)
        let manageAngle = angle + 90
        let x: Double! = manageAngle / 360.0
        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))), 2.0)
        let b = pow(sinf(Float(2 * Double.pi * ((x + 0.0) / 2))), 2)
        let c = pow(sinf(Float(2 * Double.pi * ((x + 0.25) / 2))), 2)
        let d = pow(sinf(Float(2 * Double.pi * ((x + 0.5) / 2))), 2)

        gradient.endPoint = CGPoint(x: CGFloat(c), y: CGFloat(d))
        gradient.startPoint = CGPoint(x: CGFloat(a), y: CGFloat(b))

        backgroundColor = .clear
        layer.insertSublayer(gradient, at: 0)
    }

    func setDashBorder(_ border: Border) {
        let shapeLayer = CAShapeLayer()
        let dashPattern = NSNumber(value: border.getDashWidth().native)
        shapeLayer.bounds = bounds
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = border.getColour()?.cgColor ?? UIColor.black.cgColor
        shapeLayer.lineWidth = border.getWidth()
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [dashPattern, dashPattern]
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.masksToBounds = true
        layer.addSublayer(shapeLayer)
    }
}
