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
struct BaseElement: Codable {

    let bg: Background?
    let border: Border?
    let overflow: Overflow?
    let position: Position?
    let shadow: Shadow?
    let size: Size?
    let spacing: Spacing?
    let transform: Transform?
    let flexGrow: Int?
    let flexShrink: Int?
    let flexOrder: Int?
}
