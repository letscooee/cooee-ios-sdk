//
// Created by Ashish Gaikwad on 21/10/21.
//

import Foundation
import UIKit
import AVFoundation

/**
 - Author: Ashish Gaikwad
 - Since:
 */
class InAppTriggerScene: UIView {
    @IBOutlet weak var parentView: UIView!
    private var container: UIView?

    private var triggerData: TriggerData?
    private var inAppData: InAppTrigger?

    private var sentryHelper: SentryHelper?
    private var triggerContext = TriggerContext()
    private let exit = CATransition()
    public static let instance = InAppTriggerScene()

    public func updateViewWith(data: TriggerData, on: UIViewController) throws {
        self.triggerData = data
        self.inAppData = data.getInAppTrigger()

        if self.inAppData == nil {
            throw CustomError.EmptyInAppData
        }

        container = UIView()
        triggerContext.setTriggerData(triggerData: triggerData!)
        // TODO 27/10/21: add closing provision
        setAnimations()
        renderContainerAndLayers()
        parentView.addSubview(container!)
        sendTriggerDisplayedEvent()
    }

    private func sendTriggerDisplayedEvent() {
        let event = Event(eventName: "CE Trigger Displayed", triggerData: triggerData!)
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
    }

    private func renderContainerAndLayers() {
        let containerData = inAppData?.container!
        ContainerRenderer(container!, parentView!, containerData!, inAppData!.layers!,triggerContext).render()
    }

    private func setAnimations() {
        if let animation = inAppData?.container?.animation {
            let enterAnimation = InAppAnimationProvider.getEnterAnimation(animation: animation)
            let exitAnimation = InAppAnimationProvider.getExitAnimation(animation: animation)

            overrideAnimation(enterAnimation, exitAnimation)
        }


    }

    private func overrideAnimation(_ enterAnimation: CATransitionSubtype, _ exitAnimation: CATransitionSubtype) {
        let enter = CATransition()
        enter.duration = 0.5
        enter.repeatCount = 0
        enter.type = CATransitionType.moveIn
        enter.subtype = enterAnimation
        container?.layer.add(enter, forKey: nil)


        exit.duration = 0.5
        exit.repeatCount = 0
        exit.type = CATransitionType.push
        exit.subtype = exitAnimation
    }
}
