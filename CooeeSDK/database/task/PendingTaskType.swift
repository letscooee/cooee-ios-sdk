//
// Created by Ashish Gaikwad on 07/10/21.
//

import Foundation

enum PendingTaskType: String, CaseIterable {
    case API_SEND_EVENT = "API_SEND_EVENT"
    case API_UPDATE_PROFILE = "API_UPDATE_PROFILE"
    case API_DEVICE_PROFILE = "API_DEVICE_PROFILE"
    case API_SESSION_CONCLUDE = "API_SESSION_CONCLUDE"
    case API_UPDATE_PUSH_TOKEN = "API_UPDATE_PUSH_TOKEN"
    case API_LOGOUT = "API_LOGOUT"

    static func withLabel(_ label: String) -> PendingTaskType {
        return self.allCases.first {
            "\($0)" == label
        } ?? API_SEND_EVENT
    }
}
