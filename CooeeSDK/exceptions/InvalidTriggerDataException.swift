//
// Created by Ashish Gaikwad on 06/07/22.
//

import Foundation

/**
 Custom exception class to handle invalid trigger data

 - Author: Ashish Gaikwad
 - Since: 1.3.16
 */
class InvalidTriggerDataException: NSError {
    init(message: String) {
        super.init(domain: "InvalidTriggerDataException", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
