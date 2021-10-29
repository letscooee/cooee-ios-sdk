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
class ButtonRenderer: TextRenderer {
    // MARK: Lifecycle

    override init(_ parentElement: UIView, _ elementData: BaseElement, _ triggerContext: TriggerContext, _ isFlex: Bool) {
        self.buttonData = elementData as! ButtonElement
        super.init(_: parentElement, _: elementData, _: triggerContext, _: isFlex)
    }

    // MARK: Internal

    override func render() -> UIKit.UIView {
        let button = UIButton()
        button.setTitle(buttonData.text, for: .normal)
        processTextData(button)
        return newElement!
    }

    // MARK: Private

    private var buttonData: ButtonElement
}
