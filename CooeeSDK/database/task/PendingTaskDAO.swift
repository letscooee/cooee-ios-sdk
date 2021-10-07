//
//  PendingTaskDAO.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 07/10/21.
//

import Foundation
import SQLite3

/**
 Handle insert, fetch, update, delete operations on PendingTask table

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class PendingTaskDAO {
    // MARK: Lifecycle

    init() {
        database = CooeeDatabase().database
    }

    // MARK: Internal

    func fetchPending() -> [PendingTask] {
        var taskList = [PendingTask]()
        let query = """
                    select * from \(PendingTaskConstants.TABLE_NAME) where
                    \(PendingTaskConstants.ATTEMPTS) < 20
                    """

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let model = PendingTask(id: Int(sqlite3_column_int(statement, 0)),
                        attempts: Int(sqlite3_column_int(statement, 1)),
                        dateCreated: Int64(sqlite3_column_int(statement, 2)),
                        data: String(describing: String(cString: sqlite3_column_text(statement, 3))),
                        lastAttempted: Int64(sqlite3_column_int(statement, 4)),
                        type: PendingTaskType.withLabel(String(describing: String(cString: sqlite3_column_text(statement, 5)))))

                taskList.append(model)
            }
        }
        return taskList
    }

    func delete(id: Int) {
        let query = "DELETE FROM \(PendingTaskConstants.TABLE_NAME) where \(PendingTaskConstants.ID) = \(id)"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data delete success")
            } else {
                print("Data is not deleted in table")
            }
        }
    }

    func update(pendingTask: PendingTask) {
        let query = """
                    UPDATE \(PendingTaskConstants.TABLE_NAME) SET  \(PendingTaskConstants.ATTEMPTS)= \(pendingTask.attempts),
                    \(PendingTaskConstants.LAST_ATTEMPTED) = \(pendingTask.lastAttempted ?? Int64(Date().timeIntervalSince1970))
                    WHERE \(PendingTaskConstants.ID) = \(pendingTask.id!);
                    """
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data updated success")
            } else {
                print("Data is not updated in table")
            }
        }
    }

    func insert(pendingTask: PendingTask) {
        let query = """
                    INSERT INTO \(PendingTaskConstants.TABLE_NAME)
                    (\(PendingTaskConstants.ATTEMPTS),
                    \(PendingTaskConstants.DATE_CREATED),
                    \(PendingTaskConstants.DATA),
                    \(PendingTaskConstants.TYPE))
                    VALUES (?, ?, ?, ?);
                    """

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(pendingTask.attempts))
            sqlite3_bind_int64(statement, 2, pendingTask.dateCreated)
            sqlite3_bind_text(statement, 3, pendingTask.data, -1, nil)
            sqlite3_bind_text(statement, 4, pendingTask.type.rawValue, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data inserted success")
            } else {
                print("Data is not inserted in table")
            }
        } else {
            print("Query is not as per requirement")
        }
    }

    // MARK: Private

    private let database: OpaquePointer?
}
