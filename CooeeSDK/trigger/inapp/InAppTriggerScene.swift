//
// Created by Ashish Gaikwad on 21/10/21.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI

/**
 InAppTriggerScene is a class which process iam block from payload and renders UI to the screen with the help of SwiftUI

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class InAppTriggerScene: UIView {
    var parentView: UIView!

    private var triggerData: TriggerData?
    private var inAppData: InAppTrigger?

    private var sentryHelper: SentryHelper?
    private var triggerContext = TriggerContext()
    public static let instance = InAppTriggerScene()
    private var startTime: Date? = nil

    private var deviceDefaultOrientation: UIInterfaceOrientation = UIInterfaceOrientation.portrait

    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        _ = nib.instantiate(withOwner: self, options: nil).first as! UIView
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.insetsLayoutMarginsFromSafeArea = false
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    public func updateViewWith(data: TriggerData, on viewController: UIViewController) throws {
        parentView = UIView()
        commonInit()
        self.triggerData = data
        self.inAppData = data.getInAppTrigger()

        if self.inAppData == nil {
            throw CustomError.EmptyInAppData
        }
        updateDeviceOrientation(inAppData!.getOrientation())
        triggerContext.setTriggerData(triggerData: triggerData!)
        triggerContext.setTriggerParentLayout(triggerParentLayout: parentView)
        triggerContext.setPresentViewController(presentViewController: viewController)

        triggerContext.onExit() { data in
            self.finish()
        }

        let host = UIHostingController(rootView: ContainerRenderer(inAppTrigger: inAppData!, triggerContext).edgesIgnoringSafeArea(.all))
        guard let hostView = host.view else {
            CooeeFactory.shared.sentryHelper.capture(message: "Loading SwiftUI failed")
            return
        }
        hostView.insetsLayoutMarginsFromSafeArea = false
        hostView.translatesAutoresizingMaskIntoConstraints = false
        hostView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        hostView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        parentView.addSubview(hostView)
        parentView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        if inAppData!.cont != nil && inAppData!.cont!.bg != nil && inAppData!.cont!.bg!.g != nil {
            parentView.addBlurredBackground(style: .light, alpha: inAppData!.cont!.bg!.g!.getRadius())
        }
        setAnimations()
        viewController.view.addSubview(parentView)


        startTime = Date()
        sendTriggerDisplayedEvent()
    }


    private func updateDeviceOrientation(_ orientation: UIInterfaceOrientation) {

        if let currentOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
            deviceDefaultOrientation = currentOrientation
        }

        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    private func sendTriggerDisplayedEvent() {
        let event = Event(eventName: "CE Trigger Displayed", triggerData: triggerData!)
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
    }

    private func setAnimations() {
        if let animation = inAppData?.cont?.animation {
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
        enter.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        parentView?.layer.add(enter, forKey: nil)
    }

    private func finish() {
        var closedEventProps = triggerContext.getClosedEventProps()
        let duration = DateUtils.getDateDifferenceInSeconds(startDate: startTime!, endDate: Date())
        closedEventProps.updateValue(duration, forKey: "Duration")

        var event = Event(eventName: "CE Trigger Closed", properties: closedEventProps)
        event.withTrigger(triggerData: triggerData!)
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)

        // exit animation
        let exitAnimation = inAppData!.cont?.animation?.exit ?? .SLIDE_OUT_LEFT
        UIView.animate(withDuration: 0.5, animations: {
            switch exitAnimation {
                case .SLIDE_OUT_LEFT:
                    self.parentView.frame = CGRect(x: (0 - UIScreen.main.bounds.width), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_OUT_TOP:
                    self.parentView.frame = CGRect(x: 0, y: (0 - UIScreen.main.bounds.height), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_OUT_DOWN:
                    return self.parentView.frame = CGRect(x: 0, y: (0 + UIScreen.main.bounds.height), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_OUT_RIGHT:
                    self.parentView.frame = CGRect(x: (0 + UIScreen.main.bounds.width), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }, completion: { (finished: Bool) in
            self.parentView.removeFromSuperview()
        })

        // revert device to previous device orientation
        updateDeviceOrientation(deviceDefaultOrientation)
    }
}
