//
// Created by Ashish Gaikwad on 01/11/21.
//

import Foundation
import UIKit
import SafariServices

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
        launchInAppBrowser()
        updateApp()
        share()

        closeInApp()
        // TODO 21/12/21: Add AR
    }

    /**
     Check for InApp Browser data and launch InApp Browser using SafariService
     */
    private func launchInAppBrowser(){
        if (clickAction.iab == nil || clickAction.iab!.u == nil){
            return
        }
        
        let url = URL(string: clickAction.iab!.u!)!
        let safariVC = SFSafariViewController(url: url)
        triggerContext.getPresentViewController()!.present(safariVC, animated: true, completion: nil)
    }
    
    /**
     Close InApp and give control to InAppScene
     */
    private func closeInApp() {
        if let close = clickAction.close, close {
            triggerContext.closeInApp("CTA")
        }
    }

    private func share() {
        let share = clickAction.share

        if share == nil {
            return
        }

        // text to share
        let text = share!["text"] ?? ""

        // set up activity view controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = triggerContext.getTriggerParentLayout() // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]

        // present the view controller
        triggerContext.getPresentViewController()?.present(activityViewController, animated: true, completion: nil)
    }

    private func updateApp() {
        let update = clickAction.updt

        if update == nil || (update!.u?.isEmpty ?? true) {
            return
        }

        if let url = URL(string: update!.u!) {
            UIApplication.shared.open(url)
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
        onCTAListener.onCTAResponse(payload: keyValues!)
    }
}
