//
// Created by Ashish Gaikwad on 21/10/21.
//

import AVFoundation
import Foundation
import SwiftUI
import UIKit

/**
 InAppTriggerScene is a class which process iam block from payload and renders UI to the screen with the help of SwiftUI

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class InAppTriggerScene: UIView {
    // MARK: Public

    public static let instance = InAppTriggerScene()

    public func updateViewWith(data: TriggerData, on viewController: UIViewController) throws {
        parentView = UIView()
        commonInit()
        triggerData = data
        inAppData = data.getInAppTrigger()

        publishCanvasSize()

        if inAppData == nil {
            throw CustomError.EmptyInAppData
        }
        // updateDeviceOrientation(inAppData!.getOrientation()) // Skipping orientation lock in 1.3.0 release
        triggerContext.setTriggerData(triggerData: triggerData!)
        triggerContext.setTriggerParentLayout(triggerParentLayout: parentView)
        triggerContext.setPresentViewController(presentViewController: viewController)

        triggerContext.onExit { _ in
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

        setAnimations()

        let enterAnimation = inAppData!.cont?.animation?.enter ?? .SLIDE_IN_RIGHT

        setParentPositionMoveInAnimation(enterAnimation)

        UIView.animate(withDuration: 0.5, animations: {
            viewController.view.addSubview(self.parentView)
            switch enterAnimation {
                case .SLIDE_IN_LEFT:
                    self.parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_IN_TOP:
                    self.parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_IN_DOWN:
                    return self.parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_IN_RIGHT:
                    self.parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }, completion: nil)


        startTime = Date()
        sendTriggerDisplayedEvent()
    }

    // MARK: Internal

    var parentView: UIView!

    // MARK: Private

    private var triggerData: TriggerData?
    private var inAppData: InAppTrigger?

    private var sentryHelper: SentryHelper?
    private var triggerContext = TriggerContext()
    private var startTime: Date?

    private var deviceDefaultOrientation = UIInterfaceOrientation.portrait

    /**
     Check for the Move-In animation and change the frame of parent view

     - Parameter animation: move-in animation
     */
    private func setParentPositionMoveInAnimation(_ animation: Animation.EntranceAnimation) {
        switch animation {
            case .SLIDE_IN_LEFT:
                self.parentView.frame = CGRect(x: 0 - UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_TOP:
                self.parentView.frame = CGRect(x: 0, y: 0 - UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_DOWN:
                return self.parentView.frame = CGRect(x: 0, y: 0 + UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_RIGHT:
                self.parentView.frame = CGRect(x: 0 + UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }

    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        _ = nib.instantiate(withOwner: self, options: nil).first as! UIView
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.insetsLayoutMarginsFromSafeArea = false
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func publishCanvasSize() {
        UnitUtil.STANDARD_RESOLUTION_WIDTH = inAppData?.getCanvasWidth() ?? 1080
        UnitUtil.STANDARD_RESOLUTION_HEIGHT = inAppData?.getCanvasHeight() ?? 1920
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
        let exitAnimation = inAppData!.cont?.animation?.exit ?? .SLIDE_OUT_RIGHT
        UIView.animate(withDuration: 0.5, animations: {
            switch exitAnimation {
                case .SLIDE_OUT_LEFT:
                    self.parentView.frame = CGRect(x: 0 - UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_OUT_TOP:
                    self.parentView.frame = CGRect(x: 0, y: 0 - UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_OUT_DOWN:
                    return self.parentView.frame = CGRect(x: 0, y: 0 + UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_OUT_RIGHT:
                    self.parentView.frame = CGRect(x: 0 + UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }, completion: { (_: Bool) in
            self.parentView.removeFromSuperview()
        })

        // revert device to previous device orientation
        // updateDeviceOrientation(deviceDefaultOrientation) // Skipping orientation lock in 1.3.0 release
    }
}
