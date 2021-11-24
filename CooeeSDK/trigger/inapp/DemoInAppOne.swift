//
//  DemoInAppOne.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 01/11/21.
//

import SwiftUI

struct DemoInAppOne: View {
    // MARK: Lifecycle

    init(data triggerData: TriggerData) {
        self.triggerData = triggerData
        self.inApp = triggerData.getInAppTrigger()!
    }

    // MARK: Internal

    let triggerData: TriggerData
    let inApp: InAppTrigger

    var body: some View {
        let container = inApp.cont

        ZStack {
            // process children
            ProcessChildren(inApp.elems!)
        }
        .modifier(CustomFrameModifier(elementData: container!))
    }
}

struct ProcessChildren: View {
    // MARK: Lifecycle

    init(_ children: [[String: Any]]) {
        self.children = children
    }

    // MARK: Internal

    let children: [[String: Any]]

    var body: some View {
        ForEach(0 ..< children.count) { i in
            let child = children[i]
            CreateSpecificView(child: child).gesture(
                TapGesture()
                    .onEnded { _ in
                        _ = print("clicked")
                    }
            )
        }
    }
}

struct CreateSpecificView: View {
    // MARK: Lifecycle

    init(child: [String: Any]) {
        self.child = child
        self.transformedChild = BaseElement.deserialize(from: child)!
    }

    // MARK: Internal

    let child: [String: Any]
    let transformedChild: BaseElement

    var body: some View {
        if ElementType.TEXT == transformedChild.getElementType() {
            let textElement = TextElement.deserialize(from: child)

            ProcessParts(textElement!)
        } else if ElementType.BUTTON == transformedChild.getElementType() {
            let buttonElement = TextElement.deserialize(from: child)

            ProcessParts(buttonElement!)
        } else if ElementType.IMAGE == transformedChild.getElementType() {
            let imageElement = ImageElement.deserialize(from: child)

            // process image
            ImageRenderer(
                url: URL(string: imageElement!.src!)!,
                placeholder: {
                    // Image("placeholder").frame(width: 40) // etc.
                },
                image: {
                    $0.resizable() // etc.
                }
            ).modifier(CustomFrameModifier(elementData: imageElement!))
        }
    }
}

struct ProcessParts: View {
    // MARK: Lifecycle

    init(_ element: TextElement) {
        self.parentTextElement = element
        self.childrens = element.prs!
    }

    // MARK: Internal

    let parentTextElement: TextElement
    let childrens: [PartElement]

    var body: some View {
        ForEach(childrens) { child in

            let temp = child.getPartText().trimmingCharacters(in: .whitespacesAndNewlines)
            if temp!.count > 0 {
                Text(child.child.getPartText()).modifier(CustomFrameModifier(elementData: parentTextElement, isText: true, part: child))
            }
        }
    }
}

struct CustomFrameModifier: ViewModifier {
    var elementData: BaseElement
    var isText: Bool = false
    var part: TextElement? = nil
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height

    @State var font = SwiftUI.Font.system(size: 14)

    @ViewBuilder func body(content: Content) -> some View {
        // process height and width
//        let calculatedHeight = elementData.getCalculatedHeight() ?? deviceHeight
//        let calculatedWidth = elementData.getCalculatedWidth() ?? deviceWidth
//        _ = print("\(elementData)")
//        _ = print("x: \(elementData.getX()), y: \(elementData.getY())")
//        _ = print("h: \(calculatedHeight), w: \(calculatedWidth), dh: \(deviceHeight), dw: \(deviceWidth)")
//        if !isText {
//            content
//                // .offset(x: elementData.getX(), y: elementData.getY())
//                // .position(x: elementData.getX(), y: elementData.getY())
//                .if(elementData.spc != nil) { $0.padding(.bottom, elementData.spc!.getPaddingBottom())
//                    .padding(.top, elementData.spc!.getPaddingTop())
//                    .padding(.leading, elementData.spc!.getPaddingLeft())
//                    .padding(.trailing, elementData.spc!.getPaddingRight())
//                }
//                .if(elementData.bg != nil && elementData.bg!.s != nil && elementData.bg!.s!.g != nil) {
//                    $0.background(
//                        LinearGradient(gradient: SwiftUI.Gradient(colors: [Color(hex: elementData.bg!.s!.g!.c1!), Color(hex: elementData.bg!.s!.g!.c2!)]), startPoint: .top, endPoint: .bottom)
//                    )
//                }
//                .if(elementData.bg != nil && elementData.bg!.s != nil && elementData.bg!.s!.g == nil) {
//                    $0.background(Color(hex: elementData.bg!.s!.h!, alpha: elementData.bg!.s!.getAlpha()).offset(x: elementData.getX().pixelsToPoints(), y: elementData.getY().pixelsToPoints()))
//                    // process image and glossy
//                }
//                .if(elementData.br != nil && elementData.br!.getStyle() == Border.Style.SOLID) {
//                    $0.overlay(
//                        RoundedRectangle(cornerRadius: elementData.br!.getRadius())
//                            .stroke(Color(hex: elementData.br!.getColour(), alpha: elementData.br!.getAlpha()), lineWidth: elementData.br!.getWidth())
//                            .offset(x: elementData.getX().pixelsToPoints(), y: elementData.getY().pixelsToPoints())
//                    )
//                }
//                .if(elementData.br != nil && elementData.br!.getStyle() == Border.Style.DASH) {
//                    $0.overlay(
//                        RoundedRectangle(cornerRadius: elementData.br!.getRadius())
//                            .strokeBorder(
//                                style: StrokeStyle(
//                                    lineWidth: elementData.br!.getWidth(),
//                                    dash: [elementData.br!.getDashGap(), elementData.br!.getDashWidth()]
//                                )
//                            )
//                            .foregroundColor(Color(hex: elementData.br!.getColour(), alpha: elementData.br!.getAlpha()))
//                    )
//                }.if(elementData.shadow != nil) {
//                    $0.shadow(radius: CGFloat(elementData.shadow!.getElevation()))
//                }
//                .frame(width: calculatedWidth, height: calculatedHeight, alignment: .center)
//                .position(x: elementData.getX(), y: elementData.getY())
//
//        } else {
//            let textParent = elementData as! TextElement
//
//            content
//                .if(elementData.spc != nil) { $0.padding(.bottom, elementData.spc!.getPaddingBottom())
//                    .padding(.top, elementData.spc!.getPaddingTop())
//                    .padding(.leading, elementData.spc!.getPaddingLeft())
//                    .padding(.trailing, elementData.spc!.getPaddingRight())
//                }
//                .if(elementData.bg != nil && elementData.bg!.s != nil && elementData.bg!.s!.g != nil) {
//                    $0.background(
//                        LinearGradient(gradient: SwiftUI.Gradient(colors: [Color(hex: elementData.bg!.s!.g!.c1!), Color(hex: elementData.bg!.s!.g!.c2!)]), startPoint: .top, endPoint: .bottom)
//                    )
//                }
//                .if(elementData.bg != nil && elementData.bg!.s != nil && elementData.bg!.s!.g == nil) {
//                    $0.background(Color(hex: elementData.bg!.s!.h!, alpha: elementData.bg!.s!.getAlpha())
//                        .offset(x: elementData.getX().pixelsToPoints(), y: elementData.getY().pixelsToPoints()))
//                    // process image and glossy
//                }.position(x: elementData.getX(), y: elementData.getY())
//                .offset(x: elementData.getX(), y: elementData.getY())
//
//                .if(elementData.br != nil && elementData.br!.getStyle() == Border.Style.SOLID) {
//                    $0.overlay(
//                        RoundedRectangle(cornerRadius: elementData.br!.getRadius())
//                            .stroke(Color(hex: elementData.br!.getColour(), alpha: elementData.br!.getAlpha()), lineWidth: elementData.br!.getWidth())
//                            .offset(x: elementData.getX().pixelsToPoints(), y: elementData.getY().pixelsToPoints())
//                    )
//                }
//                .if(elementData.br != nil && elementData.br!.getStyle() == Border.Style.DASH) {
//                    $0.overlay(
//                        RoundedRectangle(cornerRadius: elementData.br!.getRadius())
//                            .strokeBorder(
//                                style: StrokeStyle(
//                                    lineWidth: elementData.br!.getWidth(),
//                                    dash: [elementData.br!.getDashGap(), elementData.br!.getDashWidth()]
//                                )
//                            )
//                            .foregroundColor(Color(hex: elementData.br!.getColour(), alpha: elementData.br!.getAlpha()))
//                    )
//                }.if(elementData.shadow != nil) {
//                    $0.shadow(radius: CGFloat(elementData.shadow!.getElevation()))
//                }.if(textParent.c != nil) {
//                    $0.foregroundColor(Color(hex: textParent.c!.getColour(), alpha: textParent.c!.getAlpha()))
//                }
//
//                .if(textParent.f != nil) {
//                    $0.font(updateFontSize(size: textParent.f!.getSize()))
//                }
////            .if(part!.isBold()){
////                    $0.font(updateToBold())                }
////                    .if(part!.isItalic()){
////
////                    $0.font(updateToItalic())
////                }
////            .if(part!.addUnderLine()){
////                    $0.underline()
////                }.if(part!.addStrickThrough()){
////                    $0.strikethrough(true)
////                }
//        }
        content
    }
}

// #if DEBUG
// struct DemoInAppOne_Previews: PreviewProvider {
//    static var previews: some View {
//        DemoInAppOne(data: TriggerData())
//    }
// }
// #endif
