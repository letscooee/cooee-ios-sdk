//
// Created by Ashish Gaikwad on 27/10/21.
//

import Foundation
import UIKit

/**
 Renders the top most container of the in-app.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class ContainerRenderer: AbstractInAppRenderer {

    private var layers: [Layer]
    private var container: UIView

    init(_ container: UIView, _ parentView: UIView, _ element: Container, _ layers: [Layer], _ triggerContext: TriggerContext) {
        self.layers = layers
        self.container = container
        super.init(triggerContext: triggerContext, elementData: element, parentElement: parentView, isFlex: true)
    }

    override func render() -> UIView {
        newElement = container
        processCommonBlocks()
        processChildren()
        return newElement!
    }

    public func processChildren() {
        for layer in layers {
            _ = LayerRenderer(newElement!, layer, triggerContext, true).render()
        }
    }
}
