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
    // MARK: Lifecycle

    init(_ parentElement: UIView, _ elementData: BaseElement, _ triggerContext: TriggerContext, _ isFlex: Bool) {
        self.textData = elementData as! TextElement
        super.init(triggerContext: triggerContext, elementData: elementData, parentElement: parentElement, isFlex: isFlex)
    }

    // MARK: Internal

    override func render() -> UIView {
        if textData.parts != nil, !(textData.parts!.isEmpty) {
            processParts()
        } else {
            let textView = UILabel()
            textView.text = textData.text
            processTextData(textView)
        }
        processCommonBlocks()
        return newElement!
    }

    internal func processTextData(_ view: UIView) {
        newElement = view

        processFontBlock()
        processAlignmentBlock()
        processColourBlock()
    }

    // MARK: Private

    private var textData: TextElement

    private func processColourBlock() {
        if textData.clr == nil {
            return
        }

        (newElement as! UILabel).textColor = textData.clr!.getColour()
    }

    private func processAlignmentBlock() {
        if textData.alg == nil {
            return
        }

        (newElement as! UILabel).textAlignment = textData.getAlignment()
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
            // TODO: 27/10/21: watch for size of element
            _ = TextRenderer(newElement!, child, triggerContext, isFlex).render()
        }
    }
}
