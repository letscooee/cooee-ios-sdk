//
// Created by Ashish Gaikwad on 22/10/21.
//

import Foundation
import UIKit

/**

 Process Enter and Exit animation for the In-App

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class InAppAnimationProvider {

    /**
     Check and write enter animation of the In-App

     - Parameter animation: Optional Animation
     - Returns: CATransitionSubtype
     */
    public static func getEnterAnimation(animation: Animation?) -> CATransitionSubtype {

        if animation == nil || animation?.enter == nil {
            return CATransitionSubtype.fromLeft
        }

        switch animation?.enter! {
        case .SLIDE_IN_LEFT:
            return CATransitionSubtype.fromLeft
        case .SLIDE_IN_TOP:
            return CATransitionSubtype.fromTop
        case .SLIDE_IN_DOWN:
            return CATransitionSubtype.fromBottom
        case .SLIDE_IN_RIGHT:
            return CATransitionSubtype.fromRight
        case .none:
            return CATransitionSubtype.fromLeft
        }
    }

    /**
     Check and write exit animation of the In-App

     - Parameter animation: Optional Animation
     - Returns: CATransitionSubtype
     */
    public static func getExitAnimation(animation: Animation?) -> CATransitionSubtype {

        if animation == nil || animation?.exit == nil {
            return CATransitionSubtype.fromLeft
        }

        switch animation?.exit! {
        case .SLIDE_OUT_LEFT:
            return CATransitionSubtype.fromLeft
        case .SLIDE_OUT_TOP:
            return CATransitionSubtype.fromTop
        case .SLIDE_OUT_DOWN:
            return CATransitionSubtype.fromBottom
        case .SLIDE_OUT_RIGHT:
            return CATransitionSubtype.fromRight
        case .none:
            return CATransitionSubtype.fromLeft
        }
    }
}
