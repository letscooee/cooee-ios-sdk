//
//  TriggerData.swift
//  CooeeSDK
//
//  Created by Surbhi Lath on 09/03/21.
//

import UIKit


public class NotificationPayload: NSObject{
    
    public override init() {}
    public static let shared = NotificationPayload()
    
    public func getPayload(on viewController: UIViewController){
        if let path = Bundle.main.path(forResource: "triggerData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
                do {
                     let decodedResponse = try JSONDecoder().decode(DataTriggered.self, from: data)
                    CustomPopup.instance.updateViewWith(data: decodedResponse.data.triggerData, on: viewController)
                }catch{
                    print(error)
                }
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
    
    public func getPayload2(on viewController: UIViewController){
        if let path = Bundle.main.path(forResource: "triggerData2", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
                do {
                     let decodedResponse = try JSONDecoder().decode(DataTriggered.self, from: data)
                    CustomPopup.instance.updateViewWith(data: decodedResponse.data.triggerData, on: viewController)
                }catch{
                    print(error)
                }
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
    public func getPayload3(on viewController: UIViewController){
        if let path = Bundle.main.path(forResource: "triggerData3", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
                do {
                     let decodedResponse = try JSONDecoder().decode(DataTriggered.self, from: data)
                    CustomPopup.instance.updateViewWith(data: decodedResponse.data.triggerData, on: viewController)
                }catch{
                    print(error)
                }
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
    public func getPayload4(on viewController: UIViewController){
        if let path = Bundle.main.path(forResource: "triggerData4", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
                do {
                     let decodedResponse = try JSONDecoder().decode(DataTriggered.self, from: data)
                    CustomPopup.instance.updateViewWith(data: decodedResponse.data.triggerData, on: viewController)
                }catch{
                    print(error)
                }
            } catch {
                print (error)
            }
        }
    }
    
    public func getPayload(from dataString: String,viewController: UIViewController ){
        
        if let data = dataString.data(using: .utf8, allowLossyConversion: false){
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
                do {
                    let decodedResponse = try JSONDecoder().decode(DataTriggered.self, from: data)
                    CustomPopup.instance.updateViewWith(data: decodedResponse.data.triggerData, on: viewController)
                }catch{
                    print(error)
                }
            }catch{
                print (error)
            }
        }
    }
    
    public func getPayload(from dict: [String: Any],viewController: UIViewController ){
        
           do {
                let jsonResult =  try JSONSerialization.data(withJSONObject: dict)
               do {
                    let decodedResponse = try JSONDecoder().decode(DataClass.self, from: jsonResult)
                    CustomPopup.instance.updateViewWith(data: decodedResponse.triggerData, on: viewController)
                    
                }catch{
                    print(error)
                }
            }catch{
                print (error)
            }
        }
    
}
