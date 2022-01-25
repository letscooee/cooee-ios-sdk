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
    // MARK: Public

    /**
     Fetch the readable path to the device document directory.

     - Returns: readable path of the directory
     */
    public static func getFontsStorageDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    // MARK: Internal

    static func checkAndUpdateBrandFonts() {
        confirmFontsFromPreference()
        cacheBrandFonts()
    }

    // MARK: Private

    /**
     Gets writable path to the device document directory

     - Returns: writable path of the document directory.
     */
    private static func getFontsStorageDirectoryWritable() -> URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            NSLog("Fail to get write access \(error)")
            return URL(string: "")!
        }
    }

    /**
     Fetch App config from server and cache the fonts.
     */
    private static func cacheBrandFonts() {
        if !isItTimeToRefreshFontsFromServer() {
            NSLog("Skipping font check as its before \(Constants.FONT_REFRESH_INTERVAL_DAYS) days")
            return
        }

        let appID = CooeeFactory.shared.infoPlistReader.getAppID()

        if appID.isEmpty {
            NSLog("Skipping getAppConfig as appID is not available")
        }

        do {
            let data = try CooeeFactory.shared.baseHttpService.getAppConfig(appID: appID)

            if data == nil {
                return
            }

            if let fontList = data!["fonts"] {
                let map = fontList as! [[String: Any]]

                downloadFonts(rawFontList: map.toJsonString)
                LocalStorageHelper.putInt(key: Constants.STORAGE_LAST_FONT_ATTEMPT, value: Int(Date().timeIntervalSince1970))
            }

        } catch {
        }
    }

    /**
     Check when was the last time the server was hit to check for updated fonts.

     - Returns: returns true if this is the first attempt from the server or if it's been {@link Constants#FONT_REFRESH_INTERVAL_DAYS}
       days we last hit the server.
     */
    private static func isItTimeToRefreshFontsFromServer() -> Bool {
        let date = Date()

        let lastCheckDate = LocalStorageHelper.getInt(key: Constants.STORAGE_LAST_FONT_ATTEMPT, defaultValue: 0).doubleValue

        if lastCheckDate == 0 {
            return true
        }

        let previousDate = Calendar.current.date(byAdding: .day, value: Constants.FONT_REFRESH_INTERVAL_DAYS, to: Date(timeIntervalSince1970: lastCheckDate))

        if previousDate == nil {
            return true
        }

        return previousDate! < date
    }

    private static func confirmFontsFromPreference() {
        let stringArray = LocalStorageHelper.getString(key: Constants.STORAGE_CACHED_FONTS)

        downloadFonts(rawFontList: stringArray)
    }

    private static func downloadFonts(any: [AppFont?]) {
        downloadFonts(rawFontList: any.toJsonString)
    }

    private static func downloadFonts(rawFontList: String?) {
        if rawFontList == nil || rawFontList!.count == 0 {
            return
        }

        let outputList = [AppFont].deserialize(from: rawFontList)

        if outputList == nil {
            NSLog("Received empty font list")
            return
        }

        downloadFonts(from: outputList!)
    }

    /**
     Check if font is present at file system or not. Otherwise proceed to download font

     - Parameter fontList: {@link Array} of {@link AppFont}
     */
    private static func downloadFonts(from fontList: [AppFont?]) {
        let fontDirectory = getFontsStorageDirectory()

        for appFont in fontList {
            if appFont == nil {
                continue
            }

            var fileUrl = fontDirectory.appendingPathComponent("\(appFont!.getName()).ttf")

            if FileManager.default.fileExists(atPath: fileUrl.path) {
                continue
            }

            fileUrl = getFontsStorageDirectoryWritable().appendingPathComponent("\(appFont!.getName()).ttf")

            downloadFont(appFont!, atPath: fileUrl)
        }

        let array = fontList.compactMap {
            $0
        }
        LocalStorageHelper.putTypedArray(key: Constants.STORAGE_CACHED_FONTS, array: array)
    }

    /**
     Download file from web and store at given URL

     - Parameters:
       - fontData: will instance of {@link AppFont}
       - filePath: will be instance of {@link URL} to write new downloaded file
     */
    private static func downloadFont(_ fontData: AppFont, atPath filePath: URL) {
        let url = fontData.getURL()

        if url == nil {
            return
        }

        do {
            try CooeeFactory.shared.baseHttpService.downloadFont(url!, atPath: filePath)
        } catch {
            CooeeFactory.shared.sentryHelper.capture(error: error as NSError)
        }
    }
}
