//
// Created by Ashish Gaikwad on 21/10/21.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI

/**
 - Author: Ashish Gaikwad
 - Since:
 */
class InAppTriggerScene: UIView {
    var parentView: UIView!
    private var container: UIView?

    private var triggerData: TriggerData?
    private var inAppData: InAppTrigger?

    private var sentryHelper: SentryHelper?
    private var triggerContext = TriggerContext()
    private let exit = CATransition()
    public static let instance = InAppTriggerScene()
    private var startTime: Date? = nil

//    override init (frame : CGRect) {
//        super.init(frame : frame)
//        //Bundle.main.loadNibNamed("CustomPopup", owner: self, options: nil)
//        commonInit()
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        _ = nib.instantiate(withOwner: self, options: nil).first as! UIView
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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

        container = UIView()
        container?.frame = parentView.frame
        triggerContext.setTriggerData(triggerData: triggerData!)
        triggerContext.setTriggerParentLayout(triggerParentLayout: parentView)
        // TODO 27/10/21: add closing provision
        setAnimations()
        triggerContext.onExit(){data in self.finish()}
        
        let host = UIHostingController(rootView: ContainerRenderer(inAppTrigger: inAppData!, triggerContext))
        guard let hostView = host.view else {
            print("fail to load swiftUI")
            return
        }
        hostView.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(parentView)
        parentView.addSubview(hostView)
        
        startTime = Date()
        sendTriggerDisplayedEvent()
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
        container?.layer.add(enter, forKey: nil)


        exit.duration = 0.5
        exit.repeatCount = 0
        exit.type = CATransitionType.push
        exit.subtype = exitAnimation
    }
    
    private func finish(){
        var closedEventProps = triggerContext.getClosedEventProps()
        let duration = DateUtils.getDateDifferenceInSeconds(startDate: startTime!, endDate: Date())
        closedEventProps.updateValue(duration, forKey: "Duration")
        
        var event = Event(eventName: "CE Trigger Closed", properties: closedEventProps)
        event.withTrigger(triggerData: triggerData!)
        CooeeFactory.shared.safeHttpService.sendEvent(event: event)
        parentView!.removeFromSuperview()
    }
}
