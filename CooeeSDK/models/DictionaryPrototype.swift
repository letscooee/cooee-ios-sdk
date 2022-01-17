//
// Created by Ashish Gaikwad on 11/10/21.
//

import Foundation
import HandyJSON

struct DictionaryPrototype: HandyJSON {

    var userProperties: [String: Any]?
    var userData: [String: Any]?
    var sessionID: String?
    var props: [String: Any]?
    var occurred: Date?
    var firebaseToken: String?

    func toDictionary() -> [String: Any] {
        [
            "sessionID": sessionID ?? "",
            "occurred": occurred ?? ""
        ] as [String: Any]
    }

    func toProfileDictionary() throws -> [String: Any] {
        [
            "sessionID": sessionID ?? "",
            "userProperties": userProperties ?? "",
            "userData": userData ?? ""
        ] as [String: Any]
    }
    
    func toDeviceDictionary() throws -> [String: Any] {
        [
            "sessionID": sessionID ?? "",
            "userProperties": userProperties ?? "",
            "props": props ?? ""
        ] as [String: Any]
    }
}
