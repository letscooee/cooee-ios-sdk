//
//  InAppTriggerSceneTest.swift
//  CooeeSDKTests
//
//  Created by Ashish Gaikwad on 05/04/22.
//

@testable import CooeeSDK
import XCTest

class InAppTriggerSceneTest: BaseTestCase {
    enum PayloadProperty: String {
        case BG, BR, SPC, CLC, SHD, TRF, GVT, ANIM, ELEMS, CONT, IAN
    }

    var inAppTriggerScene: MockInAppTriggerScene!
    var viewController: UIViewController!

    override func setUpWithError() throws {
        continueAfterFailure = false
        inAppTriggerScene = MockInAppTriggerScene()
        try super.setUpWithError()
        viewController = UIApplication.shared.windows.filter {
            $0.isKeyWindow
        }.first?.rootViewController?.topMostViewController()
    }

    override func tearDownWithError() throws {
        inAppTriggerScene = nil
        try super.tearDownWithError()
    }

    func commonPassCode() {
        XCTAssertNotNil(triggerData)
        XCTAssertNotNil(viewController)
        do {
            try inAppTriggerScene.updateViewWith(data: triggerData, on: viewController)

            let delayExpectation = XCTestExpectation()
            delayExpectation.isInverted = true
            wait(for: [delayExpectation], timeout: 5)
            
            XCTAssertTrue(inAppTriggerScene.isCalledAddViewToParentView)
        } catch {
            XCTAssertNil(error)
        }
    }

    func commonFailCode() {
        XCTAssertNotNil(triggerData)
        XCTAssertNotNil(viewController)
        do {
            try inAppTriggerScene.updateViewWith(data: triggerData, on: viewController)

            XCTAssertFalse(inAppTriggerScene.isCalledAddViewToParentView)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func createUpdatedTriggerData(_ property: PayloadProperty){
        let updatedPayload = samplePayload.replacingOccurrences(of: property.rawValue.lowercased(), with: "\(property.rawValue.lowercased())x")
        triggerData = TriggerData.deserialize(from: updatedPayload)
    }

    func test_valid_inapp_trigger() throws {
        commonPassCode()
    }

    func test_invalid_inapp_trigger() throws {
        triggerData = TriggerData()
        commonFailCode()
    }
    
    func test_valid_inapp_trigger_no_bg() throws {
        createUpdatedTriggerData(.BG)
        commonPassCode()
    }
    
    func test_valid_inapp_trigger_no_br() throws {
        createUpdatedTriggerData(.BR)
        commonPassCode()
    }
    
    func test_valid_inapp_trigger_no_spacing() throws {
        createUpdatedTriggerData(.SPC)
        commonPassCode()
    }
    
    func test_valid_inapp_trigger_no_click_action() throws {
        createUpdatedTriggerData(.CLC)
        commonPassCode()
    }
    
    func test_valid_inapp_trigger_no_shadow() throws {
        createUpdatedTriggerData(.SHD)
        commonPassCode()
    }
    
    func test_valid_inapp_trigger_no_transform() throws {
        createUpdatedTriggerData(.TRF)
        commonPassCode()
    }
    
    func test_valid_inapp_trigger_no_gravity() throws {
        createUpdatedTriggerData(.GVT)
        commonPassCode()
    }
    
    func test_valid_inapp_trigger_no_animation() throws {
        createUpdatedTriggerData(.ANIM)
        commonPassCode()
    }
    
    func test_valid_inapp_trigger_no_elements() throws {
        createUpdatedTriggerData(.ELEMS)
        commonFailCode()
    }
    
    func test_valid_inapp_trigger_no_container() throws {
        createUpdatedTriggerData(.CONT)
        commonFailCode()
    }
    
    func test_valid_inapp_trigger_no_inapp() throws {
        createUpdatedTriggerData(.IAN)
        commonFailCode()
    }
}

class MockInAppTriggerScene: InAppTriggerScene {
    var isCalledUpdateViewWith = false
    var isCalledAddViewToParentView = false

    override func updateViewWith(data: TriggerData, on viewController: UIViewController) throws {
        isCalledUpdateViewWith = true
        try super.updateViewWith(data: data, on: viewController)
    }

    override func addViewToParentView(_ hostView: UIView) -> Bool {
        isCalledAddViewToParentView = true
        return false
    }
}
