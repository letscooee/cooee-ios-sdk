//
//  BaseTextElement.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 19/10/21.
//

import Foundation

protocol BaseTextElement: BaseElement {

    var text: String? { get }
    var alignment: Alignment? { get }
    var font: Font? { get }
    var colour: Colour? { get }
}
