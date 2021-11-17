//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import UIKit

/**
 Renders a ButtonElement

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class ButtonRenderer: AbstractInAppRenderer {
    // MARK: Lifecycle

    init(_ parentElement: UIView, _ elementData: BaseElement, _ triggerContext: TriggerContext, _ isFlex: Bool) {
        self.buttonData = elementData as! ButtonElement
        super.init(triggerContext: triggerContext, elementData: elementData, parentElement: parentElement, isFlex: isFlex)
    }

    // MARK: Internal

    override func render() -> UIKit.UIView {
        let button = UIButton()
        button.setTitle(buttonData.text, for: .normal)
        processTextData(button)
        return newElement!
    }

    internal func processTextData(_ view: UIView) {
        newElement = view

        processFontBlock()
        processAlignmentBlock()
        processColourBlock()
    }

    // MARK: Private

    private var buttonData: ButtonElement

    private func processColourBlock() {
        if buttonData.clr == nil {
            return
        }

        (newElement as! UIButton).setTitleColor(buttonData.clr!.getColour(), for: .normal)
    }

    private func processAlignmentBlock() {
        if buttonData.alg == nil {
            return
        }

        (newElement as! UIButton).contentHorizontalAlignment = buttonData.getButtonAlignment()
    }

    private func processFontBlock() {
        if buttonData.font == nil {
            return
        }

        (newElement as! UIButton).titleLabel?.font = UIFont.systemFont(ofSize: buttonData.font!.getSize())
    }
}
