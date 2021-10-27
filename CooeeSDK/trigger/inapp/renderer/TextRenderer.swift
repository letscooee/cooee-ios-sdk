//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import UIKit

/**
 Renders a TextElement
 
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class TextRenderer: AbstractInAppRenderer {

    private var textData: TextElement

    init(_ parentElement: UIView, _ elementData: BaseElement, _ triggerContext: TriggerContext) {
        self.textData = elementData as! TextElement
        super.init(triggerContext: triggerContext, elementData: elementData, parentElement: parentElement)
    }

    override func render() -> UIView {
        if textData.parts != nil && !(textData.parts!.isEmpty) {
            self.processParts()
        } else {
            let textView = UILabel()
            textView.text = textData.text
            self.processTextData(textView)
        }

        return newElement!
    }

    internal func processTextData(_ view: UIView) {
        newElement = view

        self.processFontBlock()
        self.processAlignmentBlock()
        self.processColourBlock()
    }

    private func processColourBlock() {
        if textData.colour == nil {
            return
        }

        (newElement as! UILabel).textColor = textData.colour!.getColour()
    }

    private func processAlignmentBlock() {
        if textData.alignment == nil {
            return
        }

        (newElement as! UILabel).textAlignment = textData.alignment!.getAlignment()
    }

    private func processFontBlock() {
        if textData.font == nil {
            return
        }

        (newElement as! UILabel).font = UIFont.systemFont(ofSize: textData.font!.getSize())
    }

    private func processParts() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        newElement = stackView
        processCommonBlocks()

        for child in textData.parts! {
            // TODO 27/10/21: watch for size of element
            _ = TextRenderer(newElement!, child, triggerContext).render()
        }
    }
}
