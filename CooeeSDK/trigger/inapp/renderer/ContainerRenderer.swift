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
class ContainerRenderer {

    private var layers: [Layer]

    init(_ container: UIView, _ parentView: UIView, _ element: Container, _ layers: [Layer], _ triggerContext: TriggerContext) {
        self.layers = layers
    }

    public func processChildren() {
        for layer in layers {
            // TODO 27/10/21: process layer renderer
        }
    }
}
