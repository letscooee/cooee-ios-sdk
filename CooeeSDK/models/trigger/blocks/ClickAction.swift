//
//  ClickAction.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct ClickAction: Codable {
    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        iab = try values.decode(BrowserContent.self, forKey: .iab)
        external = try values.decode(BrowserContent.self, forKey: .external)
        updateApp = try values.decode(BrowserContent.self, forKey: .updateApp)
        prompts = try values.decode([String].self, forKey: .prompts)
        up = try values.decode([String: AnyValue].self, forKey: .up)
        kv = try values.decode([String: AnyValue].self, forKey: .kv)
        share = try values.decode([String: AnyValue].self, forKey: .share)
        close = try values.decode(Bool.self, forKey: .close)
        appAR = try values.decode(AppAR.self, forKey: .appAR)
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case iab, external, updateApp, prompts, up, share, kv, close, appAR
    }

    let iab: BrowserContent?
    let external: BrowserContent?
    let updateApp: BrowserContent?
    let prompts: [String]?
    let up: [String: AnyValue]
    let kv: [String: AnyValue]
    let share: [String: AnyValue]
    var close: Bool? = false
    let appAR: AppAR?

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(iab, forKey: .iab)
        try container.encode(external, forKey: .external)
        try container.encode(updateApp, forKey: .updateApp)
        try container.encode(prompts, forKey: .prompts)
        try container.encode(up, forKey: .up)
        try container.encode(kv, forKey: .kv)
        try container.encode(share, forKey: .share)
        try container.encode(close, forKey: .close)
        try container.encode(appAR, forKey: .appAR)
    }
}
