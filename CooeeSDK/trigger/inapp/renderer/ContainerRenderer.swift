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
class ContainerRenderer: GroupRenderer {

    private var layers: [Layer]
    private var container: UIView

    init(_ container: UIView, _ parentView: UIView, _ element: Container, _ layers: [Layer], _ triggerContext: TriggerContext) {
        self.layers = layers
        self.container = container
        super.init(parentView, element, triggerContext, true)
    }

    override func render() -> UIView {
        newElement = container
        processCommonBlocks()
        return newElement!
    }

    override func processSizePositionBlock() {
        let deviceInfo = CooeeFactory.shared.deviceInfo
        let calculatedWidth = deviceInfo.getDeviceWidth()
        let calculatedHeight = deviceInfo.getDeviceHeight()
        let calculatedX = elementData.getX(self.parentElement)
        let calculatedY = elementData.getY(self.parentElement)
        print("calculated Width \(calculatedWidth)")
        print("calculated Height \(calculatedHeight)")

        self.newElement?.frame = CGRect(x: calculatedX, y: calculatedY, width: calculatedWidth, height: calculatedHeight)
    }
}
