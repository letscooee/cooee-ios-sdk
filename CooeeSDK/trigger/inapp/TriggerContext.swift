//
// Created by Ashish Gaikwad on 22/10/21.
//

import Foundation
import UIKit


/**
 A simple data holder class shared across different renderers.

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class TriggerContext {
    // MARK: Public

    public func getTriggerData() -> TriggerData? {
        triggerData
    }

    public func setTriggerData(triggerData: TriggerData) {
        self.triggerData = triggerData
    }

    public func getTriggerParentLayout() -> UIView? {
        triggerParentLayout
    }

    public func setTriggerParentLayout(triggerParentLayout: UIView) {
        self.triggerParentLayout = triggerParentLayout
    }
    
    public func closeInApp(_ closeBehaviour: String){
        closedEventProps.updateValue(closeBehaviour, forKey: "closeBehaviour")
        callback!(nil)
    }
    
    public func onExit(callback: @escaping (_ result: [String: Any]?) -> ()) {
        self.callback = callback
    }
    
    public func getClosedEventProps() -> [String: Any]{
        closedEventProps
    }

    public func getPresentViewController() -> UIViewController? {
        presentViewController
    }

    public func setPresentViewController(presentViewController: UIViewController) {
        self.presentViewController = presentViewController
    }

    // MARK: Private

    private var triggerData: TriggerData?
    private var triggerParentLayout: UIView?
    private var closedEventProps = [String: Any]()
    private var callback: ((_ result: [String: Any]?) -> ())?
    private var presentViewController: UIViewController?
}
