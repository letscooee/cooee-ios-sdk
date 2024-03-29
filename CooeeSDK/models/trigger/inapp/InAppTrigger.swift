//
// Created by Ashish Gaikwad on 21/10/21.
//

import Foundation
import HandyJSON
import SwiftUI

/**
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class InAppTrigger: BaseElement {
    // MARK: Public

    public func getGravity() -> SwiftUI.Alignment {
        if gvt == nil {
            gvt = cont?.getGravity()
        }

        switch gvt {
            case 1:
                return SwiftUI.Alignment.topLeading
            case 2:
                return SwiftUI.Alignment.top
            case 3:
                return SwiftUI.Alignment.topTrailing
            case 4:
                return SwiftUI.Alignment.leading
            case 6:
                return SwiftUI.Alignment.trailing
            case 7:
                return SwiftUI.Alignment.bottomLeading
            case 8:
                return SwiftUI.Alignment.bottom
            case 9:
                return SwiftUI.Alignment.bottomTrailing
            case .none:
                return SwiftUI.Alignment.center
            case .some:
                return SwiftUI.Alignment.center
        }
    }

    func containValidData() throws -> Bool {
        try hasValidImageResource() && (cont?.hasValidImageResource() ?? false) && !(elems?.isEmpty ?? true) && containsValidChildren()
    }

    private func containsValidChildren() throws -> Bool {
        for element in elems! {
            let baseElement = BaseElement.deserialize(from: element)
            if ElementType.TEXT == baseElement!.getElementType() {
                if let textElement = TextElement.deserialize(from: element) {
                    if try (!textElement.hasValidImageResource()) {
                        return false
                    }
                }
            } else if ElementType.BUTTON == baseElement!.getElementType() {
                if let textElement = TextElement.deserialize(from: element) {
                    if try (!textElement.hasValidImageResource()) {
                        return false
                    }
                }
            } else if ElementType.IMAGE == baseElement!.getElementType() {
                if let textElement = ImageElement.deserialize(from: element) {
                    if try (!textElement.hasValidImageResource()) {
                        return false
                    }
                }
            } else if ElementType.SHAPE == baseElement!.getElementType() {
                if let textElement = ShapeElement.deserialize(from: element) {
                    if try (!textElement.hasValidImageResource()) {
                        return false
                    }
                }
            }
        }
        return true
    }

    override public func getBackground() -> Background? {
        // Todo: Remove Implementation once the background is implemented in CP
        if super.getBackground() == nil {
            super.setBackground(cont?.getBackground())
            cont?.setBackground(nil)
        }

        return super.getBackground()
    }

    override public func getClickAction() -> ClickAction {
        clc ?? ClickAction(shouldClose: true)
    }

    public func getDeviceOrientation() -> UIInterfaceOrientation {
        let deviceOrientation = UIDevice.current.orientation

        if ori == 1 && deviceOrientation == .portrait {
            return .portrait
        } else if ori == 1 && deviceOrientation == .portraitUpsideDown {
            return .portraitUpsideDown
        } else if ori == 1 {
            return .portrait
        } else if ori == 2 && deviceOrientation == .landscapeLeft {
            return .landscapeLeft
        } else if ori == 2 && deviceOrientation == .landscapeRight {
            return .landscapeRight
        } else if ori == 2 {
            return .landscapeRight
        } else {
            return .unknown
        }
    }

    // MARK: Internal

    var cont: Container? // Container
    var elems: [[String: Any]]? // Elements
    var anim: Animation? // Animation

    // MARK: Private

    private var gvt: Int? // In-App contaoner gravity
    private var ori: Int? // In-App orientation
}
