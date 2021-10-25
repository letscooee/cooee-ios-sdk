//
// Created by Ashish Gaikwad on 22/10/21.
//

import Foundation
import UIKit

/**
 Process all common propertied of the element

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class AbstractInAppRenderer: InAppRenderer {


    internal var triggerContext: TriggerContext
    internal var elementData: BaseElement
    internal var parentElement: UIView

    /**
     The newest element that will be rendered by the instance of this renderer.
     */
    internal var newElement: UIView?

    init(triggerContext: TriggerContext, elementData: BaseElement, parentElement: UIView) {
        self.triggerContext = triggerContext
        self.elementData = elementData
        self.parentElement = parentElement
    }

    func render() -> UIView {
        return UIView()
    }

    internal func processCommonBlocks() {
        self.processBackground()
        self.processBorderBlock()
        self.processShadowBlock()
    }

    private func processShadowBlock() {
        let shadow = elementData.shadow

        if shadow == nil {
            return
        }

        let shadowColour = shadow!.getColour()
        let elevation = shadow!.getElevation()

        self.newElement?.dropShadow(elevation: elevation, colour: shadowColour)
    }

    private func processBorderBlock() {
        if elementData.border == nil {
            return
        }

        let border = elementData.border!

        let borderColor = border.getColour() ?? UIColor.clear
        let cornerRadius = border.getRadius(parentElement)

        if border.getStyle() == Border.Style.SOLID {
            self.newElement?.layer.borderColor = borderColor.cgColor
            self.newElement?.layer.borderWidth = CGFloat(border.getWidth(parentElement))

        } else if border.getStyle() == Border.Style.DASH {
            self.newElement?.addDashedBorder(colour: borderColor, width: border.getWidth(parentElement),
                    dashWidth: border.getDashWidth(parentElement), dashGap: border.getDashGap(parentElement),
                    cornerRadius: cornerRadius)
        }

        self.newElement?.layer.cornerRadius = CGFloat(border.getRadius(parentElement))

    }

    private func processBackground() {
        if self.elementData.bg == nil {
            return
        }

        let background = self.elementData.bg!

        if background.solid != nil {
            self.newElement?.backgroundColor = background.solid!.getColour()
        } else if background.glossy != nil {
            self.applyGlassmorphism(background.glossy!)
        } else if background.image != nil {
            self.applyBackgroundImage(background.image!)
        }

    }

    private func applyBackgroundImage(_ image: Image) {
        DispatchQueue.main.async {
            let data = try? Data(contentsOf: URL(string: image.url!)!)
            if let imageData = data {
                if let uiImage = UIImage(data: imageData) {
                    self.newElement!.backgroundColor = UIColor(patternImage: uiImage)
                }
            }
        }
    }

    private func applyGlassmorphism(_ glossy: Glossy) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.newElement!.bounds
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.newElement!.addSubview(blurEffectView)
    }
}
