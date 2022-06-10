//
//  PendingTriggerDAO.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 08/06/22.
//

import CoreData
import Foundation

/**
 DAO for PendingTrigger to fetch, update, delete and insert data.

 - Author: Ashish Gaikwad 08/06/22
 - Since:1.3.16
 */
class PendingTriggerDAO {
    // MARK: Lifecycle

    init() {
        database = CooeeDatabase.shared.persistentContainer
    }

    // MARK: Internal

    /**
     Inserts the given trigger into the Database and load triggers content to store it.

     - Parameter pendingTrigger: The trigger data to be inserted.
     - Returns: The inserted stored trigger.
     */
    func insert(_ pendingTrigger: PendingTriggerModel) -> PendingTrigger {
        let context = database.viewContext
        let trigger = NSEntityDescription.insertNewObject(forEntityName: "PendingTrigger", into: context) as! PendingTrigger
        trigger.triggerId = pendingTrigger.triggerId
        trigger.notificationId = pendingTrigger.notificationId
        trigger.triggerTime = pendingTrigger.triggerTime
        trigger.scheduleAt = pendingTrigger.scheduleAt
        trigger.triggerData = pendingTrigger.triggerData
        trigger.sdkCode = Int32(pendingTrigger.sdkCode)
        trigger.loadedLazyData = pendingTrigger.loadedLazyData

        do {
            try context.save()
        } catch {
        }
        return trigger
    }

    /**
     Access all pending triggers from database in descending order.

     - Returns: All pending triggers in descending order.
     */
    func fetchTriggers() -> [PendingTrigger] {
        let context = database.viewContext

        let fetchRequest = NSFetchRequest<PendingTrigger>(entityName: "PendingTrigger")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "triggerTime", ascending: false)]

        do {
            let pendingTriggers = try context.fetch(fetchRequest)
            return pendingTriggers
        } catch _ {
        }
        return [PendingTrigger]()
    }

    /**
     Access Pending trigger from database with given trigger ID.

     - Parameter triggerId: The trigger ID to be searched.
     - Returns: The pending trigger with given trigger ID.
     */
    func fetchTriggerWithTriggerId(_ triggerId: String) -> PendingTrigger? {
        let context = database.viewContext

        let fetchRequest = NSFetchRequest<PendingTrigger>(entityName: "PendingTrigger")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "triggerTime", ascending: false)]
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "triggerId == %@", triggerId)

        do {
            let pendingTriggers = try context.fetch(fetchRequest)
            if pendingTriggers.isEmpty {
                return nil
            }
            return pendingTriggers[0]
        } catch _ {
        }
        return nil
    }

    /**
     Delete the pending trigger with given trigger ID.

     - Parameter triggerId: The trigger ID to be deleted.
     */
    func deleteTriggerByTriggerId(_ triggerId: String) {
        let context = database.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PendingTrigger")
        fetchRequest.predicate = NSPredicate(format: "triggerId == %@", triggerId)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch _ {
        }
    }

    /**
    Update the pending trigger with given trigger instance.

     - Parameter pendingTrigger: The pending trigger to be updated.
     */
    func delete(_ pendingTrigger: PendingTrigger) {
        let context = database.viewContext
        context.delete(pendingTrigger)
    }

    /**
    Update the pending trigger with given trigger instance.

     - Parameter pendingTrigger: The pending trigger to be updated.
     */
    func update(_ pendingTrigger: PendingTrigger) {
        let context = database.viewContext

        do {
            let results = try? context.existingObject(with: pendingTrigger.objectID)

            if results != nil {
                results?.setValue(pendingTrigger.loadedLazyData, forKey: "loadedLazyData")
                results?.setValue(pendingTrigger.triggerData, forKey: "triggerData")
            }

            try context.save()

        } catch {
        }
    }
    
    func deleteAll(){
        let context = database.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PendingTrigger")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch _ as NSError {
        }
    }

    // MARK: Private

    private let database: NSPersistentContainer
}
