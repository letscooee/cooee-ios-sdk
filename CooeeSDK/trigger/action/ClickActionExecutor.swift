//
// Created by Ashish Gaikwad on 01/11/21.
//

import Foundation
import UIKit

/**
 Process ClickAction of the element and work accordingly

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

    /**
     Execute all the key properties from ClickAction
     */
    public func execute() {
        passKeyValueToApp()
        updateUserProperties()
        executeExternal()

        closeInApp()
        // TODO 01/11/21: Add In-App browser and AR
    }

    /**
     Close InApp and give control to InAppScene
     */
    private func closeInApp() {
        if let close = clickAction.close, close {
            triggerContext.closeInApp("CTA")
        }
    }

    /**
     Process external block from ClickAction and opens URL in external browser
     */
    private func executeExternal() {
        let external = clickAction.ext

        if external == nil || (external!.u?.isEmpty ?? true) {
            return
        }

        if let url = URL(string: external!.u!) {
            UIApplication.shared.open(url)
        }

    }

    /**
     Process UserProperties block in ClickAction and send it to server
     */
    private func updateUserProperties() {
        let userProperties = clickAction.up

        if userProperties == nil {
            return
        }

        CooeeFactory.shared.safeHttpService.updateUserPropertyOnly(userProperty: userProperties!)
    }

    /**
     Process KeyValue block in ClickAction and sends it back to App via CooeeCTADelegate
     */
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
