//
//  LocalStorageHelper.swift
//  CooeeSDKTests
//
//  Created by Ashish Gaikwad on 04/04/22.
//

@testable import CooeeSDK
import XCTest

class LocalStorageHelperTest: XCTestCase {
    let STORAGE_TEST_KEY = "TEST_STORAGE"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_store_string() {
        let value = "This is test storage"
        LocalStorageHelper.putString(key: STORAGE_TEST_KEY, value: value)
        
        let storedValue = LocalStorageHelper.getString(key: STORAGE_TEST_KEY)
        
        XCTAssertEqual(value, storedValue)
    }
    
    func test_store_int() {
        let value = 2345
        LocalStorageHelper.putInt(key: STORAGE_TEST_KEY, value: value)
        
        let storedValue = LocalStorageHelper.getInt(key: STORAGE_TEST_KEY, defaultValue: 0)
        
        XCTAssertEqual(value, storedValue)
    }
    
    func test_store_bool() {
        let value = true
        LocalStorageHelper.putBoolean(key: STORAGE_TEST_KEY, value: value)
        
        let storedValue = LocalStorageHelper.getBoolean(key: STORAGE_TEST_KEY, defaultValue: false)
        
        XCTAssertEqual(value, storedValue)
    }
    
    func test_store_long() {
        let value: Int64 = 987645321035156
        LocalStorageHelper.putLong(key: STORAGE_TEST_KEY, value: value)
        
        let storedValue = LocalStorageHelper.getLong(key: STORAGE_TEST_KEY, defaultValue: 0)
        
        XCTAssertEqual(value, storedValue)
    }
    
    func test_store_typed_array() {
        let embeddedTrigger = EmbeddedTrigger(triggerID: "TID-1", engagementID: "EID-1", expireAt: 5432)
        let array = [embeddedTrigger]
        LocalStorageHelper.putTypedArray(key: STORAGE_TEST_KEY, array: array)
        
        let storedArray: [EmbeddedTrigger] = LocalStorageHelper.getTypedArray(key: STORAGE_TEST_KEY, clazz: EmbeddedTrigger.self)
        
        XCTAssertNotNil(storedArray)
        XCTAssertEqual(storedArray.count, 1)
        XCTAssertEqual(embeddedTrigger.getExpireAt(), storedArray[0].getExpireAt())
    }
    
    func test_store_typed_class() {
        let embadedTrigger = EmbeddedTrigger(triggerID: "TID-1", engagementID: "EID-1", expireAt: 5432)
        
        LocalStorageHelper.putTypedClass(key: STORAGE_TEST_KEY, data: embadedTrigger)
        
        let storedArray: EmbeddedTrigger? = LocalStorageHelper.getTypedClass(key: STORAGE_TEST_KEY, clazz: EmbeddedTrigger.self)
        
        XCTAssertNotNil(storedArray)
        XCTAssertEqual(embadedTrigger.getExpireAt(), storedArray?.getExpireAt())
    }

    func test_store_dictionary() {
        let dictionary = [
            "string": "foo",
            "int": 12,
            "bool": true,
            "double": 12.12
        ] as [String : Any]
        
        LocalStorageHelper.putDictionary(dictionary, for: STORAGE_TEST_KEY)
        
        let storedDictionary = LocalStorageHelper.getDictionary(STORAGE_TEST_KEY, defaultValue: nil)
        
        XCTAssertNotNil(storedDictionary)
        XCTAssertEqual(dictionary["string"] as? String, storedDictionary?["string"] as? String)
        XCTAssertEqual(dictionary["int"] as? Int, storedDictionary?["int"] as? Int)
        XCTAssertEqual(dictionary["bool"] as? Bool, storedDictionary?["bool"] as? Bool)
        XCTAssertEqual(dictionary["double"] as? Double, storedDictionary?["double"] as? Double)
    }
}
