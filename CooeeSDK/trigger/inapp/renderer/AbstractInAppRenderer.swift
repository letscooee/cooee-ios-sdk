//
// Created by Ashish Gaikwad on 22/10/21.
//

import FlexLayout
import Foundation
import UIKit

/**
 Process all common propertied of the element

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class AbstractInAppRenderer: InAppRenderer {
    // MARK: Lifecycle

    init(triggerContext: TriggerContext, elementData: BaseElement, parentElement: UIView, isFlex: Bool) {
        self.triggerContext = triggerContext
        self.elementData = elementData
        self.parentElement = parentElement
        self.isFlex = isFlex
    }

    // MARK: Internal

    internal var triggerContext: TriggerContext
    internal var elementData: BaseElement
    internal var parentElement: UIView

    /**
     The newest element that will be rendered by the instance of this renderer.
     */
    internal var newElement: UIView?
    internal var isFlex: Bool

    func render() -> UIView {
        return UIView()
    }

    internal func processCommonBlocks() {
        self.processSizePositionBlock()
        self.processBackground()
        self.processBorderBlock()
        self.processShadowBlock()
        self.processTransformBlock()
        self.applyFlexItemProperties()
        self.processSpacing()
        self.processClickBlock()

        // TODO: 26/10/21: Check for position apply of UIView
        // self.applyPositionBlock()
        self.processMaxSize()
        self.applyFlexParentProperties()
        self.addElementToHierarchy()
    }

    private func processClickBlock() {
        let clickAction = self.elementData.getClickAction()

        if clickAction == nil {
            return
        }

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkAction))
        self.newElement!.addGestureRecognizer(gesture)

    }

    @objc func checkAction(sender: UITapGestureRecognizer) {
        print("******************* Taped")
    }

    func updateSize(_ contentWidth: CGFloat, _ contentHeight: CGFloat) {
        let size = self.elementData.getSize()

        if size.display == Size.Display.FLEX {
            self.newElement?.frame.size.width = self.parentElement.frame.width
        }

        if let contentSize = self.newElement?.intrinsicContentSize.height {
            self.newElement?.frame.size.height = contentSize
        }

        if let calculatedWidth = size.getCalculatedWidth(parentElement) {
            print("calculated Width \(calculatedWidth)")
            self.newElement?.frame.size.width = calculatedWidth
        } else {
            self.newElement?.frame.size.width = contentWidth.pixelsToPoints()
        }

        if let calculatedHeight = size.getCalculatedHeight(parentElement) {
            print("calculated Height \(calculatedHeight)")
            self.newElement?.frame.size.height = calculatedHeight
        } else {
            self.newElement?.frame.size.height = contentHeight.pixelsToPoints()
        }
    }

    // MARK: Private

    private func addElementToHierarchy() {
        if self.isFlex {
            self.parentElement.flex.addItem(self.newElement!)
        } else {
            print("Is Not Flex")
            self.parentElement.addSubview(self.newElement!)
        }
    }

    private func processMaxSize() {
        let size = self.elementData.getSize()
        let currentWidth = self.newElement!.frame.width
        let currentHeight = self.newElement!.frame.height
        print("Current Height: \(currentHeight) Width: \(currentWidth)")
        if let calculatedMaxWidth = size.getCalculatedMaxWidth(self.parentElement), calculatedMaxWidth < currentWidth {
            print("calculated Max-Width \(calculatedMaxWidth)")
            self.newElement?.frame.size.width = calculatedMaxWidth
        }

        if let calculatedMaxHeight = size.getCalculatedMaxHeight(self.parentElement), calculatedMaxHeight < currentHeight {
            print("calculated Max-Height \(calculatedMaxHeight)")
            self.newElement?.frame.size.height = calculatedMaxHeight
        }
    }

    private func processSpacing() {
        var spacing = self.elementData.spc

        if spacing == nil {
            return
        }

        spacing!.calculatedPaddingAndMargin(self.parentElement)

        /*let marginLeft = spacing!.getMarginLeft(self.parentElement)
        let marginRight = spacing!.getMarginRight(self.parentElement)
        let marginTop = spacing!.getMarginTop(self.parentElement)
        let marginBottom = spacing!.getMarginBottom(self.parentElement)

        self.newElement?.layoutMargins = UIEdgeInsets(top: marginTop, left: marginLeft, bottom: marginBottom, right: marginRight)*/

        // TODO: 26/10/21: Check for padding
    }

    internal func processSizePositionBlock() {

        let calculatedWidth = elementData.getCalculatedWidth()
        let calculatedHeight = elementData.getCalculatedHeight()
        let calculatedX = elementData.getX(self.parentElement)
        let calculatedY = elementData.getY(self.parentElement)
        print("calculated Width \(calculatedWidth)")
        print("calculated Height \(calculatedHeight)")

        self.newElement?.frame = CGRect(x: calculatedX, y: calculatedY, width: calculatedWidth!, height: calculatedHeight!)
        //self.newElement?.frame.size.height = calculatedHeight

        /*self.newElement?.translatesAutoresizingMaskIntoConstraints = true
        self.parentElement.setNeedsLayout()
        self.newElement?.layoutIfNeeded()
        self.newElement?.autoresizingMask = [.flexibleHeight, .flexibleWidth]*/
    }

    private func applyFlexItemProperties() {
        if !(self.newElement!.isKind(of: Flex.self)) {
            return
        }

        if let flexGrow = self.elementData.getFlexGrow() {
            self.newElement?.flex.grow(flexGrow)
        }

        if let flexShrink = self.elementData.getFlexShrink() {
            self.newElement?.flex.shrink(flexShrink)
        }

        // TODO: 26/10/21: Check for flexOrder
//        if let flexOrder=self.elementData.getFlexOrder(){
//            self.newElement?.flex.order(flexOrder)
//        }
    }

    private func applyFlexParentProperties() {
        if !(self.elementData.getElementType() == ElementType.GROUP) {
            return
        }

        let size = self.elementData.getSize()

        self.newElement!.flex.direction(size.getDirection())
                .wrap(size.getWrap())
                .justifyContent(size.getJustifyContent())
                .alignItems(size.getAlignItem())
                .alignContent(size.getAlignContent())
    }

    private func processTransformBlock() {
        let transform = self.elementData.trf

        if transform == nil {
            return
        }

        self.newElement?.rotate(angle: transform!.getRotation())
    }

    private func processShadowBlock() {
        let shadow = self.elementData.shadow

        if shadow == nil {
            return
        }

        let shadowColour = shadow!.getColour()
        let elevation = shadow!.getElevation()

        self.newElement?.dropShadow(elevation: elevation, colour: shadowColour)
    }

    private func processBorderBlock() {
        if self.elementData.br == nil {
            return
        }

        let border = self.elementData.br!

        let borderColor = border.getColour() ?? UIColor.clear
        let cornerRadius = border.getRadius(self.parentElement)

        if border.getStyle() == Border.Style.SOLID {
            self.newElement?.layer.borderColor = borderColor.cgColor
            self.newElement?.layer.borderWidth = CGFloat(border.getWidth(self.parentElement))

        } else if border.getStyle() == Border.Style.DASH {
            self.newElement?.addDashedBorder(colour: borderColor, width: border.getWidth(self.parentElement),
                    dashWidth: border.getDashWidth(self.parentElement), dashGap: border.getDashGap(self.parentElement),
                    cornerRadius: cornerRadius)
        }

        self.newElement?.layer.cornerRadius = CGFloat(border.getRadius(self.parentElement))
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
