//
//  CooeeTest.swift
//  CooeeSDKTests
//
//  Created by Ashish Gaikwad on 31/03/22.
//

@testable import CooeeSDK
import XCTest

class CooeeTest: XCTestCase {
    var cooeeSDK: CooeeSDK!
    let eventName = "Test Event"
    let validEventProperties = [
        "stringValue": "foo",
        "intValue": 123,
        "boolValue": true,
        "doubleValue": 123.123,
        "item": [
            "product-id": "foo-123",
            "product-name": "bar"
        ],
        "items": [
            [
                "product-id": "foo-123",
                "product-name": "bar"
            ],
            [
                "product-id": "foo-123",
                "product-name": "bar"
            ]
        ]
    ] as [String: Any]
    
    let invalidEventProperties = [
        "CE stringValue": "foo",
        "CE intValue": 123,
        "CE boolValue": true,
        "CE doubleValue": 123.123,
        "CE item": [
            "product-id": "foo-123",
            "product-name": "bar"
        ],
        "CE items": [
            [
                "product-id": "foo-123",
                "product-name": "bar"
            ],
            [
                "product-id": "foo-123",
                "product-name": "bar"
            ]
        ]
    ] as [String: Any]
    
    let validUserProfile = [
        "name": "Ashish Test",
        "email": "ashish@test.com",
        "mobile": "78956123",
        "isLogin": true
    ] as [String: Any]
    
    let inValidUserProfile = [
        "CE name": "Ashish Test",
        "CE email": "ashish@test.com",
        "CE mobile": "78956123",
        "CE isLogin": true
    ] as [String: Any]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cooeeSDK = CooeeSDK.getInstance()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cooeeSDK = nil
    }

    func test_send_event_with_only_name() {
        do {
            try cooeeSDK.sendEvent(eventName: eventName)
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    
    func test_send_event_with_nil_properties() {
        do {
            try cooeeSDK.sendEvent(eventName: eventName, eventProperties: nil)
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    
    func test_send_event_with_empty_properties() {
        do {
            try cooeeSDK.sendEvent(eventName: eventName, eventProperties: [String: Any]())
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    
    func test_send_event_with_valid_properties() {
        //measure {
            do {
                try cooeeSDK.sendEvent(eventName: eventName, eventProperties: validEventProperties)
                XCTAssertTrue(true)
            } catch {
                XCTAssertTrue(false, error.localizedDescription)
            }
        //}
    }
    
    func test_send_event_with_invalid_valid_properties() {
        do {
            try cooeeSDK.sendEvent(eventName: eventName, eventProperties: invalidEventProperties)
            XCTAssertTrue(false)
        } catch {
            XCTAssertNotNil(error)
            assert(error.localizedDescription == CustomError.PropertyError.errorDescription)
        }
    }
    
    func test_update_user_profile_valid() {
        //measure {
            do {
                try cooeeSDK.updateUserProfile(validUserProfile)
                XCTAssertTrue(true)
            } catch {
                XCTAssert(false)
            }
        //}
    }
    
    func test_update_user_profile_empty_property() {
        do {
            try cooeeSDK.updateUserProfile([String: Any]())
            XCTAssertTrue(true)
        } catch {
            XCTAssert(false)
        }
    }
    
    func test_update_user_profile_invalid_property() {
        do {
            try cooeeSDK.updateUserProfile(inValidUserProfile)
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(true)
            XCTAssert(error.localizedDescription == CustomError.PropertyError.errorDescription)
        }
    }
    
    func test_current_screen_name_valid() {
        measure {
            cooeeSDK.setCurrentScreen(screenName: "main")
            XCTAssertTrue(true)
        }
    }
    
    func test_current_screen_name_empty() {
        measure {
            cooeeSDK.setCurrentScreen(screenName: "")
            XCTAssertTrue(true)
        }
    }
    
    func test_get_user_ID() {
        measure {
            let userID = cooeeSDK.getUserID()
            XCTAssert(userID != nil)
        }
    }
}
