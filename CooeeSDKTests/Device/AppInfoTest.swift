//
//  AppInfoTest.swift
//  CooeeSDKTests
//
//  Created by Ashish Gaikwad on 04/04/22.
//

import XCTest
@testable import CooeeSDK

class AppInfoTest: XCTestCase {

    var appInfo: AppInfo!
    
    override func setUpWithError() throws {
        appInfo = AppInfo.shared
    }

    override func tearDownWithError() throws {
        appInfo = nil
    }

    func test_app_name() throws {
        let appName = appInfo.cachedInfo.name
        XCTAssertEqual(appName, "Cooee iOS")
    }
    
    func test_app_package(){
        let appPackage = appInfo.cachedInfo.packageName
        XCTAssertEqual(appPackage, "com.letscooee.Cooee-iOS")
    }
    
    func test_app_version(){
        let appVersion = appInfo.cachedInfo.version
        XCTAssertEqual(appVersion, "0.0.18+18")
    }
    
    func test_app_si_debuging(){
        let isDebuging = appInfo.cachedInfo.isDebugging
        XCTAssertTrue(isDebuging)
    }
}
