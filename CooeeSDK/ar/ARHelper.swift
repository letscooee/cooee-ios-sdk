//
//  ARHelper.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/01/22.
//

import AVFoundation
import CooeeOTFAR
import Foundation
import UIKit

class ARHelper {
    // MARK: Public

    @objc public static func isDataGet(_ arResponse: NSNotification) {
        guard let rawResponse = arResponse.userInfo?["data"] else {
            return
        }
        self.processAREvents(for: rawResponse)
    }

    // MARK: Internal

    /**
     Initialize the CooeeOTFAR
     */
    static func initAndShowUnity() {
        if let framework = self.unityFrameworkLoad() {
            self.unityFramework = framework
            self.unityFramework?.setDataBundleId("com.letscooee.otfar")
            self.unityFramework?.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: nil)
        }
    }

    /**
     Check for camera permission and add observer to get data from CooeeOTFAR

     - Parameters:
       - arData: ARData which will be sent to CooeeOTFAR
       - triggerData: Instance of TriggerData which will be sent with all events
       - viewController:
     */
    static func checkForARAndLaunch(with arData: AppAR, forTrigger triggerData: TriggerData?,
                                    on viewController: UIViewController) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.isDataGet(_:)),
                name: NSNotification.Name("CooeeUnityToAR"), object: nil)

        self.triggerData = triggerData

        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.launchAR(for: arData, on: viewController)
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.launchAR(for: arData, on: viewController)
                    }
                }
            case .denied: // The user has previously denied access.
                self.launchAR(for: arData, on: viewController)

            case .restricted: // The user can't grant access due to restrictions.
                self.launchAR(for: arData, on: viewController)
                break
            @unknown default: break
        }
    }

    // MARK: Private

    private static var unityFramework: CooeeOTFAR?

    private static let EVENT_NAME = "name"
    private static let EVENT_PROPERTIES = "props"
    private static let EVENT_CTA = "cta"
    private static var lastARResponse: ClickAction?
    static var triggerData: TriggerData?
    private static let CLOSE_EVENT = "CE AR Closed"
    static var IS_SELF_AR_CALL = false

    private static var unityView: UIViewController?

    /**
     Checks for CTA operation for closed AR and perform CTA
     */
    private static func processLastARResponse() {
        if self.lastARResponse == nil {
            return
        }

        guard let listener = CooeeSDK.getInstance().getOnCTAListener(), let data = lastARResponse?.kv else {
            return
        }

        listener.onCTAResponse(payload: data)
    }

    /**
     Process raw data sent via AR SDK and perform related operations

     - Parameter rawResponse: Any value sent via AR SDK
     */
    private static func processAREvents(for rawResponse: Any) {
        guard let arResponse = String(describing: rawResponse).convertToDictionary() else {
            return
        }

        var event = Event(eventName: arResponse[EVENT_NAME] as! String)

        if let eventProp = arResponse[EVENT_PROPERTIES] {
            event.properties = eventProp as? [String: Any?]
        }

        if self.triggerData != nil {
            event.withTrigger(triggerData: self.triggerData!)
        }

        CooeeFactory.shared.safeHttpService.sendEvent(event: event)

        if event.name!.caseInsensitiveCompare(self.CLOSE_EVENT) == .orderedSame || arResponse[self.EVENT_CTA] != nil {
            // self.unityView?.removeFromSuperview()
            self.unityView?.dismiss(animated: false, completion: nil)
        }

        guard let ctaResponse = arResponse[EVENT_CTA] else {
            return
        }

        self.lastARResponse = ClickAction.deserialize(from: String(describing: ctaResponse))

        guard let userProperty = lastARResponse?.up else {
            return
        }

        CooeeSDK.getInstance().updateUserProperties(userProperties: userProperty)

        self.processLastARResponse()
        self.initAndShowUnity()
    }

    /**
     Checks and load CooeeOTFAR framework

     - Returns: Optional instance of CooeeOTFAR
     */
    private static func unityFrameworkLoad() -> CooeeOTFAR? {
        let bundlePath = Bundle.main.bundlePath.appending("/Frameworks/CooeeOTFAR.framework")

        guard let unityBundle = Bundle(path: bundlePath) else {
            return nil
        }

        if let frameworkInstance = unityBundle.principalClass?.getInstance() {
            return frameworkInstance
        }

        return nil
    }

    /**
     Launched the CooeeOTFAR and sends payload to the CooeeOTFAR SDK

     - Parameters:
       - arData: ARData to be sent to AR SDK
       - viewController: Instance current UIViewController to load AR's UIViewController
     */
    private static func launchAR(for arData: AppAR, on viewController: UIViewController) {
        self.unityFramework?.showUnityWindow()
        self.unityView = self.unityFramework!.appController().rootViewController!
        self.unityFramework?.sendMessageToGO(withName: "Scene_Manager", functionName: "UnityToIOS", message: arData.toJSONString()!)
        viewController.present(self.unityFramework!.appController().rootViewController!, animated: false, completion: nil)
    }
}
