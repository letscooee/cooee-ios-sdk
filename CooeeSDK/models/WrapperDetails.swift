//
// Created by Ashish Gaikwad on 31/05/22.
//

import Foundation
import HandyJSON

/**
 WrapperDetails holds the details of the wrapper.

 - Author: Ashish Gaikwad
 - Since: 1.3.15
 */
class WrapperDetails: HandyJSON {
    required init() {
    }

    private var name: String?
    private var ver: String?
    private var code: Int?

    init(wrapperName: String, versionNumber: String, versionCode: Int) {
        name = wrapperName
        ver = versionNumber
        code = versionCode
    }

    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        if let name = name {
            dict["name"] = name
        }

        if let ver = ver {
            dict["ver"] = ver
        }

        if let code = code {
            dict["code"] = code
        }

        return dict
    }
}
