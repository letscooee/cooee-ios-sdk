//
// Created by Ashish Gaikwad on 11/10/21.
//

import Foundation
import HandyJSON

struct DictionaryPrototype: HandyJSON {
    var userProperties: [String: Any]?
    var userData: [String: Any]?
    var sessionID: String?
    var occurred: Date?
    var firebaseToken: String?

    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["sessionID"] = sessionID
        dictionary["occurred"] = occurred
        return dictionary
    }

    func toProfileDictionary() throws -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["sessionID"] = sessionID
        dictionary["userProperties"] = userProperties
        dictionary["userData"] = userData
        return dictionary
    }
}
