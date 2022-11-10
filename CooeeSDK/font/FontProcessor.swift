//
//  FontProcessor.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 21/12/21.
//

import Foundation
import HandyJSON

/**
 Check for fonts and if those are not available it will download that font.
 
 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class FontProcessor {

    /**
     Fetch the readable path to the device document directory.
     
     - Returns: readable path of the directory
     */
    public static func getFontsStorageDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    /**
     Gets writable path to the device document directory
     
     - Returns: writable path of the document directory.
     */
    private static func getFontsStorageDirectoryWritable() -> URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            NSLog("\(Constants.TAG) Fail to get write access \(error)")
            return URL(string: "")!
        }
    }

    /**
     Download all the font from the given List

     - Parameter urls: List of all font URLs from trigger
     */
    class func preCacheFonts(urls: [String]?) {
        guard let fontURLs = urls else {
            return
        }

        let fontDirectory = getFontsStorageDirectory()

        for item in fontURLs {
            guard let url = URL(string: item) else {
                continue
            }
            downloadFontAndRegister(url: url, fontDirectory: fontDirectory)
        }
    }

    class func downloadFontAndRegister(url: URL, fontDirectory: URL) {
        var fileUrl = fontDirectory.appendingPathComponent(url.lastPathComponent)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            UIFont.register(from: fileUrl)
            return
        }

        fileUrl = getFontsStorageDirectoryWritable().appendingPathComponent(url.lastPathComponent)

        do {
            try CooeeFactory.shared.baseHttpService.downloadFont(url, atPath: fileUrl)
            UIFont.register(from: fileUrl)
        } catch {
            CooeeFactory.shared.sentryHelper.capture(error: error as NSError)
        }
    }
}
