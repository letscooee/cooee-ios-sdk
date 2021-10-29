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
    // MARK: Lifecycle

    init(_ parentView: UIView, _ element: BaseElement, _ triggerContext: TriggerContext, _ isFlex: Bool) {
        super.init(triggerContext: triggerContext, elementData: element, parentElement: parentView, isFlex: isFlex)
    }

    // MARK: Internal

    override func render() -> UIView {
        if !elementData.getSize().isDisplayFlex() {
            // Group/Layer will always be FLEX OR INLINE_FLEX. If not, log it and suppress the error
            CooeeFactory.shared.sentryHelper.capture(message: "Non FLEX Group/Layer received")
        }

        newElement = UIView()
        processCommonBlocks()
        // TODO: 27/10/21: Process OverFlow
        processChildren()

        return newElement!
    }

    // MARK: Private

    private func processChildren() {
        let data = elementData
        if let groupElementData: GroupElement = data as? GroupElement {
            for child in groupElementData.children! {
                let parsedChild = BaseElement.deserialize(from: child)
                print("***************************\(parsedChild?.getElementType().rawValue)")
                if parsedChild!.getElementType() == ElementType.IMAGE {
                    _ = ImageRenderer(newElement!, ImageElement.deserialize(from: child)!, triggerContext, isFlex).render()
                } else if parsedChild!.getElementType() == ElementType.GROUP {
                    _ = GroupRenderer(newElement!, GroupElement.deserialize(from: child)!, triggerContext, isFlex).render()
                } else if parsedChild!.getElementType() == ElementType.TEXT {
                    _ = TextRenderer(newElement!, TextElement.deserialize(from: child)!, triggerContext, isFlex).render()
                } else if parsedChild!.getElementType() == ElementType.BUTTON {
                    _ = ButtonRenderer(newElement!, ButtonElement.deserialize(from: child)!, triggerContext, isFlex).render()
                }
            }
        }
    }
}
