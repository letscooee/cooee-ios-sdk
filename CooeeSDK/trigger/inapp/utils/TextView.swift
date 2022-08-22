//
//  TextView.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 19/08/22.
//

import SwiftUI
import UIKit

struct TextView: UIViewRepresentable {
    var textElement: TextElement
    @Binding var dynamicHeight: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        // textView.delegate = context.coordinator
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let textAlignment = textElement.getNSTextAlignment()
        let attributedString = NSMutableAttributedString(
            string: ""
        )
        
        processParts(attributedString)
        
        uiView.attributedText = attributedString
        uiView.textAlignment = textAlignment
        DispatchQueue.main.async {
            dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        }
    }
    
    func processParts(_ attributedString: NSMutableAttributedString) {
        for index in 0 ..< (textElement.prs?.count ?? 0) {
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
            
            attributedString.append(
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
}
