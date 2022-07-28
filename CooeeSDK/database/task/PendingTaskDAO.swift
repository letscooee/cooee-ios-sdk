//
//  PendingTaskDAO.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 07/10/21.
//

import CoreData
import Foundation
import UIKit

/**
 Handle insert, fetch, update, delete operations on PendingTask table

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class PendingTaskDAO {
    // MARK: Lifecycle

    init() {
        database = CooeeDatabase.shared.persistentContainer
    }

    // MARK: Internal

    func insert(_ pendingTask: PendingTaskModel) -> PendingTasks {
        let context = database.viewContext
        let task = NSEntityDescription.insertNewObject(forEntityName: "PendingTasks", into: context) as! PendingTasks
        task.attempts = Int32(pendingTask.attempts ?? 0)
        task.data = pendingTask.data
        task.dateCreated = pendingTask.dateCreated
        task.type = pendingTask.type.rawValue
        task.sdkCode = Int32(pendingTask.sdkVersion)

        do {
            try context.save()
        } catch {
        }
        return task
    }

    func fetchTasks() -> [PendingTasks] {
        let context = database.viewContext

        let fetchRequest = NSFetchRequest<PendingTasks>(entityName: "PendingTasks")

        do {
            let pendingTasks = try context.fetch(fetchRequest)
            return pendingTasks
        } catch _ {
        }
        return [PendingTasks]()
    }

    func delete(_ pendingTask: PendingTasks) {
        NSLog("Deleting Task \(pendingTask.id)")
        let context = database.viewContext
        context.delete(pendingTask)

        do {
            try context.save()
        } catch {
        }
    }

    func update(_ pendingTask: PendingTasks) {
        let context = database.viewContext

        do {
            let results = try? context.existingObject(with: pendingTask.objectID)

            if results != nil {
                results?.setValue(pendingTask.attempts, forKey: "attempts")
                results?.setValue(pendingTask.lastAttempted, forKey: "lastAttempted")
            }

            try context.save()

        } catch {
        }
    }

    // MARK: Private

    private let database: NSPersistentContainer
}
