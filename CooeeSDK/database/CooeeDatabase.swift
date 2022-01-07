//
//  CooeeDatabase.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 07/10/21.
//

import CoreData
import Foundation
import UIKit

/**
 Create and opens connection to the database

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class CooeeDatabase {
    // MARK: Public

    public static let shared = CooeeDatabase()

    // MARK: Internal

    lazy var persistentContainer: NSPersistentContainer = {
        let messageKitBundle = Bundle(for: type(of: self))
        let modelURL = messageKitBundle.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)

        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { _, error in

            if let err = error {
                fatalError("❌ Loading of store failed:\(err)")
            }
        }

        return container
    }()

    // MARK: Private

    private let identifier: String = "com.letscooee.CooeeSDK"
    private let model: String = "letscooee"
}
