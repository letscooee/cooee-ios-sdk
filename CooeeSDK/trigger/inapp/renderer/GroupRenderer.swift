//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import UIKit

/**
 Renders a GroupElement

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class GroupRenderer: AbstractInAppRenderer {
    init(_ parentView: UIView, _ element: BaseElement, _ triggerContext: TriggerContext) {
        super.init(triggerContext: triggerContext, elementData: element, parentElement: parentView)
    }

    override func render() -> UIView {
        if (!elementData.getSize().isDisplayFlex()) {
            // Group/Layer will always be FLEX OR INLINE_FLEX. If not, log it and suppress the error
            CooeeFactory.shared.sentryHelper.capture(message: "Non FLEX Group/Layer received");
        }

        newElement = UIView()
        processCommonBlocks()
        // TODO 27/10/21: Process OverFlow
        processChildren()

        return newElement!
    }

    private func processChildren() {
        let groupElementData = elementData as! GroupElement

        for child in groupElementData.children! {

        }
    }
}
