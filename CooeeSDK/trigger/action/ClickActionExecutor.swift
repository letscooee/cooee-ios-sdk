//
// Created by Ashish Gaikwad on 01/11/21.
//

import Foundation
import UIKit

/**
 Process ClickAction of the element

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class ClickActionExecutor {

    private let clickAction: ClickAction
    private let triggerContext: TriggerContext

    init(_ clickAction: ClickAction, _ triggerContext: TriggerContext) {
        self.clickAction = clickAction
        self.triggerContext = triggerContext
    }

    public func execute() {
        passKeyValueToApp()
        updateUserProperties()
        executeExternal()

        if let close = clickAction.close, close {
            triggerContext.getTriggerParentLayout()?.removeFromSuperview()
        }
        // TODO 01/11/21: Add In-App browser and AR
    }

    private func executeExternal() {
        let external = clickAction.ext

        if external == nil || (external!.u?.isEmpty ?? true) {
            return
        }

        if let url = URL(string: external!.u!) {
            UIApplication.shared.open(url)
        }

    }

    private func updateUserProperties() {
        let userProperties = clickAction.up

        if userProperties == nil {
            return
        }

        CooeeFactory.shared.safeHttpService.updateUserPropertyOnly(userProperty: userProperties!)
    }

    private func passKeyValueToApp() {
        let keyValues = clickAction.kv

        if keyValues == nil {
            return
        }

        guard let onCTAListener = CooeeSDK.getInstance().getOnCTAListener() else {
            return
        }
        onCTAListener(keyValues!)
    }
}
