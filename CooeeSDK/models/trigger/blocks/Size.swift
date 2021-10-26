//
//  Size.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON
import FlexLayout

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Size: HandyJSON {
    // MARK: Lifecycle

    init() {
        self.display = Display.BLOCK
    }

    // MARK: Public

    public enum Display {
        case BLOCK, INLINE_BLOCK, FLEX, INLINE_FLEX
    }

    // MARK: Internal

    var width: String?
    var height: String?
    var maxWidth: String?
    var maxHeight: String?
    var display: Display?
    private var justifyContent: FlexProperty.JustifyContent?
    private var alignItems: FlexProperty.AlignItems?
    private var wrap: FlexProperty.Wrap?
    private var alignContent: FlexProperty.AlignContent?
    private var direction: FlexProperty.Direction?

    func getDirection() -> Flex.Direction {
        direction?.description ?? FlexProperty.Direction.ROW.description
    }

    func getAlignItem() -> Flex.AlignItems {
        alignItems?.description ?? FlexProperty.AlignItems.STRETCH.description
    }

    func getWrap() -> Flex.Wrap {
        wrap?.description ?? FlexProperty.Wrap.NOWRAP.description
    }

    func getJustifyContent() -> Flex.JustifyContent {
        justifyContent?.description ?? FlexProperty.JustifyContent.FLEX_START.description
    }

    func getAlignContent() -> Flex.AlignContent {
        alignContent?.description ?? FlexProperty.AlignContent.STRETCH.description
    }
}
