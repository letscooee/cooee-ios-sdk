//
// Created by Ashish Gaikwad on 22/10/21.
//

import Foundation
import UIKit


/**
 A simple data holder class shared across different renderers.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class TriggerContext {

    private var triggerData: TriggerData?
    private var triggerParentLayout: UIView?

    public func getTriggerData() -> TriggerData? {
        triggerData
    }

    public func setTriggerData(triggerData: TriggerData) {
        self.triggerData = triggerData
    }

    public func getTriggerParentLayout() -> UIView? {
        triggerParentLayout
    }

    public func setTriggerParentLayout(triggerParentLayout: UIView) {
        self.triggerParentLayout = triggerParentLayout
    }
}
