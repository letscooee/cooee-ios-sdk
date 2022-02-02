//
// Created by Ashish Gaikwad on 01/11/21.
//

import Foundation
import SafariServices
import UIKit

/**
 Process ClickAction of the element and work accordingly

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class ClickActionExecutor {
    // MARK: Lifecycle

    init(_ clickAction: ClickAction, _ triggerContext: TriggerContext) {
        self.clickAction = clickAction
        self.triggerContext = triggerContext
    }

    // MARK: Public

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
        showAR()
        closeInApp()
    }

    // MARK: Private

    private let clickAction: ClickAction
    private let triggerContext: TriggerContext

    private func showAR() {
        guard let launchFeature = clickAction.open else {
            return
        }

        if launchFeature == 2 {
            // TODO: Launch Self AR
        } else if launchFeature == 3 {
            launchOTFAR()
        }
    }

    private func launchOTFAR() {
        /*guard let appAR = clickAction.ntvAR else {
            return
        }

        ARHelper.checkForARAndLaunch(with: appAR, forTrigger: triggerContext.getTriggerData(),
                on: triggerContext.getPresentViewController()!)*/
    }

    /**
     Check for InApp Browser data and launch InApp Browser using SafariService
     */
    private func launchInAppBrowser() {
        if clickAction.iab == nil || clickAction.iab!.u == nil {
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
        guard let close = clickAction.close else {
            return
        }

        if close, clickAction.isOnlyCloseCTA() {
            triggerContext.closeInApp("Close")
        } else {
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
