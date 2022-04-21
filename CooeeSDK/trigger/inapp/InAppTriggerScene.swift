//
// Created by Ashish Gaikwad on 21/10/21.
//

import AVFoundation
import Foundation
import Sentry
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
        triggerData = data
        self.viewController = viewController
        if parentView != nil {
            perform(#selector(renderNewInApp), with: nil, afterDelay: 5)
            finish()
        }else{
            perform(#selector(renderNewInApp), with: nil, afterDelay: 0.1)
        }
    }
    
    @objc func renderNewInApp() {
        let sentryTransaction = SentrySDK.startTransaction(
            name: SentryTransaction.COOEE_INAPP_SCENE.rawValue,
            operation: "load"
        )

        do{
            try self.renderInApp(triggerData!, viewController!)

            let enterAnimation = self.inAppData!.anim?.en ?? .SLIDE_IN_RIGHT

            self.setParentPositionMoveInAnimation(enterAnimation)

        UIView.animate(withDuration: 0.5, animations: {
            self.viewController!.view.addSubview(self.parentView)
            self.parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }, completion: nil)

            self.startTime = Date()
            self.sendTriggerDisplayedEvent()
        }catch{
            CooeeFactory.shared.sentryHelper.capture(error: error as NSError)
        }

        sentryTransaction.finish()

        NotificationCenter.default.addObserver(self, selector: #selector(self.screenRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    // MARK: Internal

    var parentView: UIView!

    @objc func screenRotated() {
        switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight, .portrait, .portraitUpsideDown:
                parentView?.removeFromSuperview()
                do {
                    try renderInApp(triggerData!, triggerContext.getPresentViewController()!)
                    triggerContext.getPresentViewController()!.view.addSubview(parentView)
                } catch {
                    CooeeFactory.shared.sentryHelper.capture(error: error as NSError)
                }
            default:
                print("other (such as face up & down)")
        }
    }

    func renderInApp(_ data: TriggerData, _ viewController: UIViewController) throws {
        parentView = UIView()
        commonInit()
        triggerData = data
        inAppData = data.getInAppTrigger()

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
    }

    // MARK: Private

    private var triggerData: TriggerData?
    private var viewController: UIViewController?
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
                parentView.frame = CGRect(x: 0 - UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_TOP:
                parentView.frame = CGRect(x: 0, y: 0 - UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_DOWN:
                return parentView.frame = CGRect(x: 0, y: 0 + UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_RIGHT:
                parentView.frame = CGRect(x: 0 + UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_TOP_LEFT:
                parentView.frame = CGRect(x: 0 - UIScreen.main.bounds.width, y: 0 - UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_TOP_RIGHT:
                parentView.frame = CGRect(x: 0 + UIScreen.main.bounds.width, y: 0 - UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_BOTTOM_LEFT:
                parentView.frame = CGRect(x: 0 - UIScreen.main.bounds.width, y: 0 + UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            case .SLIDE_IN_BOTTOM_RIGHT:
                parentView.frame = CGRect(x: 0 + UIScreen.main.bounds.width, y: 0 + UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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

    private func finish() {
        DispatchQueue.main.async {
            var closedEventProps = self.triggerContext.getClosedEventProps()
            let duration = DateUtils.getDateDifferenceInSeconds(startDate: self.startTime!, endDate: Date())
            closedEventProps.updateValue(duration, forKey: "duration")

            var event = Event(eventName: "CE Trigger Closed", properties: closedEventProps)
            event.withTrigger(triggerData: self.triggerData!)
            CooeeFactory.shared.safeHttpService.sendEvent(event: event)
        }

        // exit animation
        let exitAnimation = inAppData!.anim?.ex ?? .SLIDE_OUT_RIGHT
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
                case .SLIDE_OUT_BOTTOM_LEFT:
                    self.parentView.frame = CGRect(x: 0 - UIScreen.main.bounds.width, y: 0 + UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_OUT_BOTTOM_RIGHT:
                    self.parentView.frame = CGRect(x: 0 + UIScreen.main.bounds.width, y: 0 + UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_OUT_TOP_LEFT:
                    self.parentView.frame = CGRect(x: 0 - UIScreen.main.bounds.width, y: 0 - UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                case .SLIDE_OUT_TOP_RIGHT:
                    self.parentView.frame = CGRect(x: 0 + UIScreen.main.bounds.width, y: 0 - UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }, completion: { (_: Bool) in
            self.parentView.removeFromSuperview()
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        })

        // revert device to previous device orientation
        // updateDeviceOrientation(deviceDefaultOrientation) // Skipping orientation lock in 1.3.0 release
    }
}
