//
//  EngagementTriggerHelperTest.swift
//  CooeeSDKTests
//
//  Created by Ashish Gaikwad on 04/04/22.
//

@testable import CooeeSDK
import XCTest

class EngagementTriggerHelperTest: BaseTestCase {
    var mockEngagementTriggerHelper: MockEngagementTriggerHelper!

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockEngagementTriggerHelper = MockEngagementTriggerHelper()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        mockEngagementTriggerHelper = nil
    }

    func test_load_in_app_from_empty_response() {
        XCTAssertNotNil(samplePayloadMap)

        mockEngagementTriggerHelper.renderInAppTriggerFromResponse(response: [String: Any]())
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
    }

    func test_load_in_app_from_nil_response() {
        XCTAssertNotNil(samplePayloadMap)

        mockEngagementTriggerHelper.renderInAppTriggerFromResponse(response: nil)
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
    }

    func test_load_in_app_from_valid_response() {
        XCTAssertNotNil(samplePayloadMap)

        let response: [String: Any] = ["triggerData": samplePayloadMap as Any]
        mockEngagementTriggerHelper.renderInAppTriggerFromResponse(response: response)
        XCTAssertTrue(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
    }
    
    func test_load_in_app_from_invalid_response() {
        XCTAssertNotNil(samplePayloadMap)

        let response: [String: Any] = ["triggerData": samplePayload as Any]
        mockEngagementTriggerHelper.renderInAppTriggerFromResponse(response: response)
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
    }
    
    func test_load_in_app_from_valid_json_string() {
        XCTAssertNotNil(samplePayload)

        mockEngagementTriggerHelper.renderInAppTriggerFromJSONString(samplePayload)
        XCTAssertTrue(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
    }
    
    func test_load_in_app_from_invalid_json_string() {
        samplePayload = "Hi, this is invalid JSON string"
        XCTAssertNotNil(samplePayload)

        mockEngagementTriggerHelper.renderInAppTriggerFromJSONString(samplePayload)
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
    }
    
    func test_load_in_app_from_empty_json_string() {
        samplePayload = ""
        XCTAssertNotNil(samplePayload)

        mockEngagementTriggerHelper.renderInAppTriggerFromJSONString(samplePayload)
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
    }
    
    func test_render_in_app_from_valid_push_notification(){
        XCTAssertNotNil(triggerData)
        
        mockEngagementTriggerHelper.renderInAppFromPushNotification(for: triggerData)
        XCTAssertTrue(mockEngagementTriggerHelper.hasCalledLoadLazyData)
    }
    
    func test_render_in_app_from_invalid_push_notification(){
        mockEngagementTriggerHelper.renderInAppFromPushNotification(for: TriggerData())
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledLoadLazyData)
    }
    
    func test_load_lazy_data_from_valid_trigger(){
        XCTAssertNotNil(triggerData)
        
        mockEngagementTriggerHelper.loadLazyData(for: triggerData)
        XCTAssertTrue(mockEngagementTriggerHelper.hasCalledLoadLazyData)
    }
    
    func test_load_lazy_data_from_invalid_trigger(){
        mockEngagementTriggerHelper.loadLazyData(for: TriggerData())
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
    }
    
    func test_store_active_trigger(){
        LocalStorageHelper.remove(key: Constants.STORAGE_ACTIVATED_TRIGGERS)
        XCTAssertNotNil(triggerData)
        
        EngagementTriggerHelper.storeActiveTriggerDetails(triggerData: triggerData)
        
        let activeTriggers = EngagementTriggerHelper.getActiveTriggers()
        XCTAssertEqual(activeTriggers.count, 1)
        let embededTrigger = activeTriggers[0]
        XCTAssertEqual(embededTrigger.getExpireAt(), triggerData.expireAt)
    }
    
    func test_store_expired_trigger(){
        LocalStorageHelper.remove(key: Constants.STORAGE_ACTIVATED_TRIGGERS)
        XCTAssertNotNil(expiredTriggerData)
        
        EngagementTriggerHelper.storeActiveTriggerDetails(triggerData: expiredTriggerData)
        
        let activeTriggers = EngagementTriggerHelper.getActiveTriggers()
        XCTAssertEqual(activeTriggers.count, 0)
    }
}

class MockEngagementTriggerHelper: EngagementTriggerHelper {
    var hasCalledRenderInAppTriggerFromResponse = false
    var hasCalledRenderInAppTriggerFromJSONString = false
    var hasCalledRenderInAppFromPushNotification = false
    var hasCalledLoadLazyData = false
    var hasCalledRenderInAppTrigger = false

    override func renderInAppTriggerFromResponse(response data: [String: Any]?) {
        hasCalledRenderInAppTriggerFromResponse = true
        super.renderInAppTriggerFromResponse(response: data)
    }

    override func renderInAppTriggerFromJSONString(_ rawTriggerData: String) {
        hasCalledRenderInAppTriggerFromJSONString = true
        super.renderInAppTriggerFromJSONString(rawTriggerData)
    }

    override func renderInAppFromPushNotification(for triggerData: TriggerData) {
        hasCalledRenderInAppFromPushNotification = true
        super.renderInAppFromPushNotification(for: triggerData)
    }

    override func loadLazyData(for triggerData: TriggerData) {
        super.loadLazyData(for: triggerData)
        hasCalledLoadLazyData = true
    }

    override func renderInAppTrigger(_ data: TriggerData?) {
        hasCalledRenderInAppTrigger = true
        super.renderInAppTrigger(data)
    }
}
