//
// Created by Ashish Gaikwad on 31/05/22.
//

import Foundation
import HandyJSON

/**
 Holds device details like properties and wrapper information

 - Author: Ashish Gaikwad
 - Since: 1.3.15
 */
class DeviceDetails: HandyJSON {
    var props: [String: Any]?
    var wrp: WrapperDetails?

    required init() {

    }

    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        if let props = props {
            dict["props"] = props
        }
        if let wrp = wrp {
            dict["wrp"] = wrp.toDictionary()
        }
        return dict
    }
}
