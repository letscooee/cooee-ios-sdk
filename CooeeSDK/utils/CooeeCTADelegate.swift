//
// Created by Ashish Gaikwad on 13/12/21.
//

import Foundation

/**
 Delegate to provide response to accessor

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
public protocol CooeeCTADelegate {

    /**
     Callback to return a Key Value payload associated with inApp widget click.
     */
    func onCTAResponse(payload: [String: Any])
}
