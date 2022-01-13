//
//  SizePreferenceKey.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 13/01/22.
//

import Foundation

/**
 SizePreferenceKey allows you to keep watch on element property like height, width, etc.
 
 - Author: Ashish Gaikwad
 - Since: 1.3.5
 */
struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
