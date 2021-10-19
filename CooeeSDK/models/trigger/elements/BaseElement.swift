//
//  BaseElement.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
protocol BaseElement: Codable {
    var bg: Background? { get }
    var border: Border? { get }
    var overflow: Overflow? { get }
    var position: Position? { get set }
    var shadow: Shadow? { get }
    var size: Size? { get set }
    var spacing: Spacing? { get }
    var transform: Transform? { get }
    var flexGrow: Int? { get }
    var flexShrink: Int? { get }
    var flexOrder: Int? { get }
}

extension BaseElement {
    mutating func getSize() -> Size {
        if size == nil {
            size = Size()
        }
        return size!
    }

    mutating func getPosition() -> Position {
        if position == nil { position = Position() }
        return position!
    }
}
