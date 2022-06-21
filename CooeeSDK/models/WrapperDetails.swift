//
// Created by Ashish Gaikwad on 21/06/22.
//

import Foundation

/**
 WrapperDetails can hold wrapper information

 - Author: Ashish Gaikwad
 - Since: 1.3.16
 */
struct WrapperDetails {
    // MARK: Lifecycle

    init(_ versionCode: Int, _ version: String, _ wrapperName: WrapperType) {
        code = versionCode
        ver = version
        name = wrapperName.rawValue
    }

    // MARK: Internal

    var code: Int?
    var ver: String?
    var name: String?

    func toDictionary() -> [String: Any] {
        [
            "code": code as Any,
            "ver": ver as Any,
            "name": name as Any
        ] as [String: Any]
    }
}
