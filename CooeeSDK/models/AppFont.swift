//
//  AppFont.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/12/21.
//

import Foundation
import HandyJSON

/**
 AppFont provides name of font and url for it to download

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class AppFont:Codable, HandyJSON {
    // MARK: Lifecycle

    required init() {}

    // MARK: Public

    public func getName() -> String {
        name ?? "font"
    }

    public func getURL() -> URL? {
        URL(string: "\(url ?? "")" )
    }

    // MARK: Private

    private var name: String?
    private var url: String?
}
