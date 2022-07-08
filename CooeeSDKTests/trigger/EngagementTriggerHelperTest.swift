//
//  EngagementTriggerHelperTest.swift
//  CooeeSDKTests
//
//  Created by Ashish Gaikwad on 04/04/22.
//

@testable import CooeeSDK
import XCTest

class EngagementTriggerHelperTest: BaseTestCase {

    enum InvalidType: String {
        case EMPTY_BACKGROUND_IMAGE = "invalidBg"
        case NULL_PARTS = "nullParts"
        case EMPTY_PARTS = "emptyParts"
        case EMPTY_IMAGE_ELEMENT_URL = "emptyImage"
    }

    var mockEngagementTriggerHelper: MockEngagementTriggerHelper!

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockEngagementTriggerHelper = MockEngagementTriggerHelper()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        mockEngagementTriggerHelper = nil
    }

    func assertLoadInAppFromResponse(_ data: [String: Any]?, _ assertType: Bool) throws {
        try mockEngagementTriggerHelper.renderInAppTriggerFromResponse(response: data)

        if assertType {
            XCTAssertTrue(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
        } else {
            XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
        }
    }

    func test_load_in_app_from_empty_response() throws {
        XCTAssertNotNil(samplePayloadMap)

        try assertLoadInAppFromResponse([String: Any](), false)
    }

    func test_load_in_app_from_nil_response() throws {
        XCTAssertNotNil(samplePayloadMap)

        try assertLoadInAppFromResponse(nil, false)
    }

    func test_load_in_app_from_valid_response() throws {
        XCTAssertNotNil(samplePayloadMap)

        let response: [String: Any] = ["triggerData": samplePayloadMap as Any]
        try assertLoadInAppFromResponse(response, true)
    }

    func test_load_in_app_from_invalid_response() throws {
        XCTAssertNotNil(samplePayloadMap)

        let response: [String: Any] = ["triggerData": samplePayload as Any]
        try assertLoadInAppFromResponse(response, false)
    }

    func assertLoadInAppFromJSONString(_ assertType: Bool) throws {
        XCTAssertNotNil(samplePayload)

        try mockEngagementTriggerHelper.renderInAppTriggerFromJSONString(samplePayload)
        if assertType {
            XCTAssertTrue(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
        } else {
            XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
        }
    }

    func test_load_in_app_from_valid_json_string() throws {
        try assertLoadInAppFromJSONString(true)
    }

    func test_load_in_app_from_invalid_json_string() throws {
        samplePayload = "Hi, this is invalid JSON string"
        try assertLoadInAppFromJSONString(false)
    }

    func test_load_in_app_from_empty_json_string() throws {
        samplePayload = ""
        try assertLoadInAppFromJSONString(false)
    }

    func assertRenderInAppFromPushNotification(_ data: TriggerData, _ assertType: Bool, _ checkPendingTrigger: Bool = false) throws {
        try mockEngagementTriggerHelper.renderInAppFromPushNotification(for: data, checkPendingTrigger: checkPendingTrigger)

        if assertType {
            XCTAssertTrue(mockEngagementTriggerHelper.hasCalledLoadLazyData)
        } else {
            XCTAssertFalse(mockEngagementTriggerHelper.hasCalledLoadLazyData)
        }

        if checkPendingTrigger {
            XCTAssertTrue(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
        }
    }

    func test_render_in_app_from_valid_push_notification() throws {
        XCTAssertNotNil(triggerData)

        try assertRenderInAppFromPushNotification(triggerData, true)
    }

    func test_render_in_app_from_valid_push_notification_with_pending_trigger() throws {
        XCTAssertNotNil(triggerData)
        CacheTriggerContent().loadAndSaveTriggerData(triggerData, forNotification: "")
        try assertRenderInAppFromPushNotification(triggerData, false, true)
    }

    func test_render_in_app_from_invalid_push_notification() throws {
        try assertRenderInAppFromPushNotification(TriggerData(), false)
    }

    func test_load_lazy_data_from_valid_trigger() {
        XCTAssertNotNil(triggerData)

        mockEngagementTriggerHelper.loadLazyData(for: triggerData)
        XCTAssertTrue(mockEngagementTriggerHelper.hasCalledLoadLazyData)
    }

    func test_load_lazy_data_from_invalid_trigger() {
        mockEngagementTriggerHelper.loadLazyData(for: TriggerData())
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
    }

    func test_store_active_trigger() {
        LocalStorageHelper.remove(key: Constants.STORAGE_ACTIVATED_TRIGGERS)
        XCTAssertNotNil(triggerData)

        EngagementTriggerHelper.storeActiveTriggerDetails(triggerData: triggerData)

        let activeTriggers = EngagementTriggerHelper.getActiveTriggers()
        XCTAssertEqual(activeTriggers.count, 1)
        let embeddedTrigger = activeTriggers[0]
        XCTAssertEqual(embeddedTrigger.getExpireAt(), triggerData.expireAt)
    }

    func test_store_expired_trigger() {
        LocalStorageHelper.remove(key: Constants.STORAGE_ACTIVATED_TRIGGERS)
        XCTAssertNotNil(expiredTriggerData)

        EngagementTriggerHelper.storeActiveTriggerDetails(triggerData: expiredTriggerData)

        let activeTriggers = EngagementTriggerHelper.getActiveTriggers()
        XCTAssertEqual(activeTriggers.count, 0)
    }

    func test_organic_launch_with_empty_database() throws {
        try mockEngagementTriggerHelper.performOrganicLaunch()
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
        PendingTriggerDAO().deleteAll()
    }

    // TODO: need to update the test case to check the pending trigger
    func organic_launch_database() throws {
        let cacheContnet = CacheTriggerContent()
        cacheContnet.loadAndSaveTriggerData(triggerData, forNotification: "test")

        var proceed = false
        while !proceed {
            let latestTrigger = cacheContnet.getLatestTrigger()
            if latestTrigger?.loadedLazyData ?? false {
                proceed = true
            }
        }

        try mockEngagementTriggerHelper.performOrganicLaunch()
        XCTAssertTrue(mockEngagementTriggerHelper.hasCalledRenderInAppTrigger)
        XCTAssertFalse(mockEngagementTriggerHelper.hasCalledLoadLazyData)
        PendingTriggerDAO().deleteAll()
    }

    func test_organic_launch_database_with_non_loaded_trigger() throws {
        PendingTriggerDAO().deleteAll()
        samplePayloadMap.updateValue("T1", forKey: "id")
        let triggerData = TriggerData.deserialize(from: samplePayloadMap)
        CacheTriggerContent().loadAndSaveTriggerData(triggerData!, forNotification: "test")
        try mockEngagementTriggerHelper.performOrganicLaunch()
        XCTAssertTrue(mockEngagementTriggerHelper.hasCalledLoadLazyData)
        PendingTriggerDAO().deleteAll()
    }

    func test_render_inapp() {
        do {
            try mockEngagementTriggerHelper.renderInAppTrigger(triggerData)
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false)
        }
    }

    func test_render_inapp_with_invalid_background_image() {
        do {
            let trigger = getInvalidTrigger(.EMPTY_BACKGROUND_IMAGE)

            try mockEngagementTriggerHelper.renderInAppTrigger(trigger)
            XCTAssertTrue(false)
        } catch {
            XCTAssert(error is InvalidTriggerDataException)
        }
    }

    func test_render_inapp_with_null_parts() {
        do {
            let trigger = getInvalidTrigger(.NULL_PARTS)

            try mockEngagementTriggerHelper.renderInAppTrigger(trigger)
            XCTAssertTrue(false)
        } catch {
            XCTAssert(error is InvalidTriggerDataException)
        }
    }

    func test_render_inapp_with_empty_parts() {
        do {
            let trigger = getInvalidTrigger(.EMPTY_PARTS)

            try mockEngagementTriggerHelper.renderInAppTrigger(trigger)
            XCTAssertTrue(false)
        } catch {
            XCTAssert(error is InvalidTriggerDataException)
        }
    }

    func test_render_inapp_with_empty_image_element_src() {
        do {
            let trigger = getInvalidTrigger(.EMPTY_IMAGE_ELEMENT_URL)

            try mockEngagementTriggerHelper.renderInAppTrigger(trigger)
            XCTAssertTrue(false)
        } catch {
            XCTAssert(error is InvalidTriggerDataException)
        }
    }

    func getInvalidTrigger(_ type: InvalidType) -> TriggerData? {
        var ian = samplePayloadMap["ian"] as! [String: Any?]
        let elemets = invalidDataMap[type.rawValue]

        ian.updateValue(elemets, forKey: "elems")
        samplePayloadMap.updateValue(ian, forKey: "ian")

        return TriggerData.deserialize(from: samplePayloadMap)
    }
}

class MockEngagementTriggerHelper: EngagementTriggerHelper {
    var hasCalledRenderInAppTriggerFromResponse = false
    var hasCalledRenderInAppTriggerFromJSONString = false
    var hasCalledRenderInAppFromPushNotification = false
    var hasCalledLoadLazyData = false
    var hasCalledRenderInAppTrigger = false

    override func renderInAppTriggerFromResponse(response data: [String: Any]?) throws {
        hasCalledRenderInAppTriggerFromResponse = true
        try super.renderInAppTriggerFromResponse(response: data)
    }

    override func renderInAppTriggerFromJSONString(_ rawTriggerData: String) throws {
        hasCalledRenderInAppTriggerFromJSONString = true
        try super.renderInAppTriggerFromJSONString(rawTriggerData)
    }

    override func renderInAppFromPushNotification(for triggerData: TriggerData, checkPendingTrigger: Bool = false) throws {
        hasCalledRenderInAppFromPushNotification = true
        try super.renderInAppFromPushNotification(for: triggerData, checkPendingTrigger: checkPendingTrigger)
    }

    override func loadLazyData(for triggerData: TriggerData) {
        super.loadLazyData(for: triggerData)
        hasCalledLoadLazyData = true
    }

    override func renderInAppTrigger(_ data: TriggerData?) throws {
        hasCalledRenderInAppTrigger = true
        try super.renderInAppTrigger(data)
    }
}
