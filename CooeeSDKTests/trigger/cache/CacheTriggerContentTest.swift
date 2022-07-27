//
//  CacheTriggerContentTest.swift
//  CooeeSDKTests
//
//  Created by Ashish Gaikwad on 10/06/22.
//

@testable import CooeeSDK
import Foundation
import XCTest

class CacheTriggerContentTest: BaseTestCase {
    var mockPendingTriggerDAO: MockPendingTriggerDAO!
    var cacheTriggerContent: CacheTriggerContent!
    let delayExpectation = XCTestExpectation()

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockPendingTriggerDAO = MockPendingTriggerDAO()
        cacheTriggerContent = CacheTriggerContent(mockPendingTriggerDAO)
        delayExpectation.isInverted = true
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockPendingTriggerDAO = nil
        cacheTriggerContent = nil
    }

    func flushDatabase() {
        mockPendingTriggerDAO.deleteAll()
    }

    func insertTestCase(_ data: TriggerData) {
        cacheTriggerContent.loadAndSaveTriggerData(data, forNotification: "test")
        XCTAssertTrue(mockPendingTriggerDAO.hasCalledInsert)
    }

    func insertManyTriggers() {
        insertTestCase(triggerData)
        samplePayloadMap.updateValue("T1", forKey: "id")
        if let trigger = TriggerData.deserialize(from: samplePayloadMap) {
            insertTestCase(trigger)
        }
        samplePayloadMap.updateValue("T2", forKey: "id")
        if let trigger = TriggerData.deserialize(from: samplePayloadMap) {
            insertTestCase(trigger)
        }
        samplePayloadMap.updateValue("T3", forKey: "id")
        if let trigger = TriggerData.deserialize(from: samplePayloadMap) {
            insertTestCase(trigger)
        }
    }

    func test_load_and_save_trigger_content() {
        XCTAssertNotNil(triggerData)
        insertTestCase(triggerData)
        wait(for: [delayExpectation], timeout: 5)
        XCTAssertTrue(mockPendingTriggerDAO.hasCalledUpdate)
        flushDatabase()
    }

    func test_load_and_save_trigger_content_with_invalid_trigger_id() {
        samplePayloadMap.updateValue("T5", forKey: "id")

        if let trigger = TriggerData.deserialize(from: samplePayloadMap) {
            insertTestCase(trigger)
        }

        wait(for: [delayExpectation], timeout: 5)
        XCTAssertTrue(mockPendingTriggerDAO.hasCalledUpdate)
        flushDatabase()
    }

    func test_get_latest_trigger() {
        XCTAssertNotNil(samplePayloadMap)
        insertManyTriggers()
        samplePayloadMap.updateValue("T5", forKey: "id")
        if let trigger = TriggerData.deserialize(from: samplePayloadMap) {
            insertTestCase(trigger)
        }

        let pendingTrigger = cacheTriggerContent.getLatestTrigger()
        let pendingTriggers = mockPendingTriggerDAO.fetchTriggers()

        XCTAssertEqual(pendingTriggers.count, 5)
        XCTAssertEqual("T5", pendingTrigger?.triggerId)
        flushDatabase()
    }

    func test_get_latest_trigger_on_empty_table() {
        flushDatabase()
        let pendingTrigger = cacheTriggerContent.getLatestTrigger()
        let pendingTriggers = mockPendingTriggerDAO.fetchTriggers()

        XCTAssertEqual(pendingTriggers.count, 0)
        XCTAssertNil(pendingTrigger)
    }

    func test_get_trigger_by_trigger_id() {
        XCTAssertNotNil(samplePayloadMap)
        insertManyTriggers()

        let pendingTrigger = cacheTriggerContent.getTriggerByTriggerId("T3")
        let pendingTriggers = mockPendingTriggerDAO.fetchTriggers()

        XCTAssertEqual(pendingTriggers.count, 4)
        XCTAssertEqual("T3", pendingTrigger?.triggerId)
        flushDatabase()
    }

    func test_get_trigger_by_invalid_trigger_id() {
        XCTAssertNotNil(samplePayloadMap)
        insertManyTriggers()

        let pendingTrigger = cacheTriggerContent.getTriggerByTriggerId("T10")
        let pendingTriggers = mockPendingTriggerDAO.fetchTriggers()

        XCTAssertEqual(pendingTriggers.count, 4)
        XCTAssertNil(pendingTrigger)
        flushDatabase()
    }

    func test_delete_trigger_by_trigger_id() {
        XCTAssertNotNil(samplePayloadMap)
        insertManyTriggers()

        cacheTriggerContent.removeTrigger("T3")
        let pendingTrigger = cacheTriggerContent.getTriggerByTriggerId("T3")
        let pendingTriggers = mockPendingTriggerDAO.fetchTriggers()

        XCTAssertNil(pendingTrigger)
        XCTAssertEqual(pendingTriggers.count, 3)
        flushDatabase()
    }

    func test_delete_trigger_by_invalid_trigger_id() {
        XCTAssertNotNil(samplePayloadMap)
        insertManyTriggers()

        cacheTriggerContent.removeTrigger("T10")
        let pendingTriggers = mockPendingTriggerDAO.fetchTriggers()

        XCTAssertEqual(pendingTriggers.count, 4)
        flushDatabase()
    }

    func test_delete_trigger() {
        XCTAssertNotNil(samplePayloadMap)
        insertManyTriggers()

        let pendingTrigger = cacheTriggerContent.getTriggerByTriggerId("T3")
        cacheTriggerContent.removeTrigger(pendingTrigger!)
        let output = cacheTriggerContent.getTriggerByTriggerId("T3")
        let pendingTriggers = mockPendingTriggerDAO.fetchTriggers()

        XCTAssertNil(output)
        XCTAssertEqual(pendingTriggers.count, 3)
        flushDatabase()
    }
}

class MockPendingTriggerDAO: PendingTriggerDAO {
    var hasCalledInsert = false
    var hasCalledDelete = false
    var hasCalledDeleteByTriggerId = false
    var hasCalledUpdate = false
    var hasCalledFetch = false
    var hasCalledFetchWithTriggerId = false

    override func insert(_ pendingTrigger: PendingTriggerModel) -> PendingTrigger {
        hasCalledInsert = true
        return super.insert(pendingTrigger)
    }

    override func delete(_ pendingTrigger: PendingTrigger) {
        hasCalledDelete = true
        super.delete(pendingTrigger)
    }

    override func deleteTriggerByTriggerId(_ triggerId: String) {
        hasCalledDeleteByTriggerId = true
        super.deleteTriggerByTriggerId(triggerId)
    }

    override func update(_ pendingTrigger: PendingTrigger) {
        hasCalledUpdate = true
        super.update(pendingTrigger)
    }

    override func fetchTriggers() -> [PendingTrigger] {
        hasCalledFetch = true
        return super.fetchTriggers()
    }

    override func fetchTriggerWithTriggerId(_ triggerId: String) -> PendingTrigger? {
        hasCalledFetchWithTriggerId = true
        return super.fetchTriggerWithTriggerId(triggerId)
    }

    override func deleteAll() {
        super.deleteAll()
    }
}

extension CacheTriggerContent {
    convenience init(_ dao: PendingTriggerDAO) {
        self.init()
        pendingTriggerDAO = dao
    }
}
