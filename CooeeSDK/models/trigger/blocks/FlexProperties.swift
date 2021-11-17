//
// Created by Ashish Gaikwad on 10/11/21.
//

import Foundation
import HandyJSON
import FlexLayout

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct FlexProperties: HandyJSON {

    private var j: FlexProperty.JustifyContent?
    private var ai: FlexProperty.AlignItems?
    private var w: FlexProperty.Wrap?
    private var ac: FlexProperty.AlignContent?
    private var d: FlexProperty.Direction?

    func getDirection() -> Flex.Direction {
        d?.description ?? FlexProperty.Direction.ROW.description
    }

    func getAlignItem() -> Flex.AlignItems {
        ai?.description ?? FlexProperty.AlignItems.STRETCH.description
    }

    func getWrap() -> Flex.Wrap {
        w?.description ?? FlexProperty.Wrap.NOWRAP.description
    }

    func getJustifyContent() -> Flex.JustifyContent {
        j?.description ?? FlexProperty.JustifyContent.FLEX_START.description
    }

    func getAlignContent() -> Flex.AlignContent {
        ac?.description ?? FlexProperty.AlignContent.STRETCH.description
    }


}
