//
//  AppController.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 16/09/21.
//

import Foundation
import UIKit

/**
 Initialize CooeeSDK

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
@objc
public class AppController: NSObject {

    @objc
    public static func configure() {
        _ = CooeeBootstrap()
    }
}
