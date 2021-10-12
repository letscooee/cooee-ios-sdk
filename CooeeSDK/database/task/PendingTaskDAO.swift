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
ß
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
        } catch let fetchErr {
        }
        return [PendingTasks]()
    }

    func delete(_ pendingTask: PendingTasks) {
        let context = database.viewContext
        context.delete(pendingTask)

        do {
            try context.save()
        } catch {
        }
    }

    func update(_ pendingTask: PendingTasks) {
        let context = database.viewContext
        let fetchUser: NSFetchRequest<PendingTasks> = PendingTasks.fetchRequest()

        fetchUser.predicate = NSPredicate(format: "id = %@", "\(pendingTask.id)")

        let results = try? context.fetch(fetchUser)

        if results?.count != 0 {
            results?.first?.setValue(pendingTask.attempts, forKey: "attempts")
            results?.first?.setValue(pendingTask.lastAttempted, forKey: "lastAttempted")
        }
        do {
            try context.save()

        } catch {
        }
    }

    // MARK: Private

    private let database: NSPersistentContainer
}
