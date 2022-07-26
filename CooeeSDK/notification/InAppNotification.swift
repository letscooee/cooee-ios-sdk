//
//  InAppNotification.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/01/22.
//

import AVFoundation
import Foundation
import UIKit

public class InAppNotification: UIViewController {
    // MARK: Public

    override public func viewDidLoad() {
        // super.viewDidLoad()
        let systemSoundID: SystemSoundID = 1315

        // to play sound
        AudioServicesPlaySystemSound(systemSoundID)
        view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        let mainHeight = CGFloat((10 * UIScreen.main.bounds.height) / 100)
        swipe.direction = .up
        view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        stackView = UIStackView()
        stackView.addBlurredBackground(style: .systemChromeMaterialLight, alpha: 0)
        let mainWidth = CGFloat((90 * UIScreen.main.bounds.width) / 100)

        stackView.frame = CGRect(x: CGFloat((5 * UIScreen.main.bounds.width) / 100), y: 40, width: mainWidth, height: mainHeight)
        stackView.axis = .horizontal
        stackView.layer.cornerRadius = 15
        stackView.distribution = .fillProportionally
        stackView.addGestureRecognizer(swipe)
        stackView.addGestureRecognizer(tap)

//        let enter = CATransition()
//        enter.duration = 0.5
//        enter.repeatCount = 0
//        enter.type = CATransitionType.moveIn
//        enter.subtype = .fromTop
//        enter.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        stackView.layer.add(enter, forKey: nil)

        UIView.transition(with: view, duration: 0.8, options: .curveEaseIn, animations: {
            self.view.addSubview(self.stackView)
            self.view.bringSubviewToFront(self.stackView)
        }, completion: nil)

//      view.addSubview(stackView)

        let splitContent = image != nil

        let width = splitContent ? (stackView.frame.width * 75) / 100 : stackView.frame.width

        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillProportionally
        verticalStack.alignment = .center
        verticalStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        verticalStack.frame = CGRect(x: 0, y: 0, width: width - 20, height: mainHeight)

        let header = UILabel()
        header.text = " "
        header.font = UIFont.systemFont(ofSize: 9)
        header.textColor = UIColor.white.withAlphaComponent(1.0)
        header.numberOfLines = 1
        header.widthAnchor.constraint(equalToConstant: width - 20).isActive = true

        let title = UILabel()
        title.text = notificationContent.title
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor.black
        title.numberOfLines = 1
        title.frame.size = CGSize(width: width - 20, height: (mainHeight / 3) - 10)
        title.widthAnchor.constraint(equalToConstant: width - 20).isActive = true

        let body = UILabel()
        body.text = notificationContent.body
        body.textColor = UIColor.black
        body.numberOfLines = 1
        body.widthAnchor.constraint(equalToConstant: width - 20).isActive = true

        let footer = UILabel()
        footer.text = " "
        footer.font = UIFont.systemFont(ofSize: 9)
        footer.textColor = UIColor.white.withAlphaComponent(1.0)
        footer.numberOfLines = 1
        footer.widthAnchor.constraint(equalToConstant: width - 20).isActive = true

        verticalStack.addArrangedSubview(header)
        verticalStack.addArrangedSubview(title)
        verticalStack.addArrangedSubview(body)
        verticalStack.addArrangedSubview(footer)
        verticalStack.setContentHuggingPriority(UILayoutPriority(251), for: NSLayoutConstraint.Axis.horizontal)
        verticalStack.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true

        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        if splitContent {
            view.frame = CGRect(x: 0, y: 0, width: mainWidth - width - 20, height: mainHeight - 10)
            view.setContentHuggingPriority(UILayoutPriority(252), for: NSLayoutConstraint.Axis.horizontal)

            let vertialImageStack = UIStackView()
            vertialImageStack.axis = .horizontal
            vertialImageStack.distribution = .fillProportionally
            vertialImageStack.alignment = .center
            vertialImageStack.widthAnchor.constraint(equalToConstant: CGFloat((mainWidth - width) - 20)).isActive = true
            vertialImageStack.heightAnchor.constraint(equalToConstant: CGFloat(mainHeight - 20)).isActive = true

            let uiImage = UIImageView()
            uiImage.image = image
            uiImage.clipsToBounds = true
            uiImage.contentMode = .scaleAspectFill
            uiImage.frame = CGRect(x: 0, y: 0, width: mainWidth - width - 40, height: mainHeight - 40)
            uiImage.widthAnchor.constraint(equalToConstant: CGFloat((mainWidth - width) - 20)).isActive = true
            uiImage.heightAnchor.constraint(equalToConstant: CGFloat(mainHeight - 20)).isActive = true
            uiImage.layer.cornerRadius = 10
            uiImage.clipsToBounds = true
//            uiImage.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2)

            vertialImageStack.addArrangedSubview(uiImage)

            view.alignment = .center
            view.addArrangedSubview(vertialImageStack)
        }

        stackView.addArrangedSubview(verticalStack)
        if splitContent {
            stackView.addArrangedSubview(view)
        }
        stackView.autoresizesSubviews = true
        // stackView.distribution = .fill
        CooeeNotificationService.sendEvent(Constants.EVENT_NOTIFICATION_VIEWED, withTriggerData: triggerData)
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(triggerJob), userInfo: nil, repeats: true)
    }

    @objc public func handleTap(_ sender: UITapGestureRecognizer) {
        dismissAnimation()
        let engagementTriggerHelper = EngagementTriggerHelper()
        CooeeNotificationService.sendEvent(Constants.EVENT_NOTIFICATION_CLICKED, withTriggerData: triggerData)

        guard let notificationClickAction = triggerData.getPushNotification()?.getClickAction() else {
            engagementTriggerHelper.renderInAppFromPushNotification(for: triggerData)
            return
        }

        guard  let launchType = notificationClickAction.open else {
            engagementTriggerHelper.renderInAppFromPushNotification(for: triggerData)
            return
        }

        if launchType == 1 {
            engagementTriggerHelper.renderInAppFromPushNotification(for: triggerData)
        } else if launchType == 2 {
            // Launch Self AR
            //EngagementTriggerHelper.renderInAppFromPushNotification(for: triggerData)
        } else if launchType == 3 {
            // Launch Native AR
        }
    }

    @objc public func handleGesture(_ sender: UITapGestureRecognizer) {
        CooeeNotificationService.addPendingNotification(notificationContent, triggerData)
        dismissAnimation()
    }

    // MARK: Internal

    var stackView: UIStackView!
    var notificationContent: UNMutableNotificationContent!
    var triggerData: TriggerData!
    var image: UIImage?

    @objc
    func triggerJob() {
        CooeeNotificationService.addPendingNotification(notificationContent, triggerData)
        dismissAnimation()
    }

    func dismissAnimation() {
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.stackView.frame = CGRect(x: CGFloat((5 * UIScreen.main.bounds.width) / 100), y: 0 - self.stackView.bounds.height, width: self.stackView.bounds.width, height: self.stackView.bounds.height)
        }, completion: { (_: Bool) in
            self.stackView.removeFromSuperview()
            self.dismiss(animated: false, completion: nil)
        })
    }

    // MARK: Internal
}

extension UILabel {
    private enum AssociatedKeys {
        static var padding = UIEdgeInsets()
    }

    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            drawText(in: rect.inset(by: insets))
        } else {
            drawText(in: rect)
        }
    }

    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else {
            return super.intrinsicContentSize
        }

        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0

        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }

        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: font!], context: nil)

        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth

        return contentSize
    }
}
