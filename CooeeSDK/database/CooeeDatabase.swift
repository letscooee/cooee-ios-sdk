//
//  CooeeDatabase.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 07/10/21.
//

import Foundation
import SQLite3

/**
 Create and opens connection to the database

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class CooeeDatabase {
    // MARK: Lifecycle

    init() {
        database = createDatabase()
        createPendingTaskTable()
    }

    // MARK: Internal

    var database: OpaquePointer?

    // MARK: Private

    private let databasePath = "letscooee.sqlite"

    /**
     Create database if does not exist and returns database reference
     - Returns: return database reference if operation is successful else <code>nil</code>
     */
    private func createDatabase() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(databasePath)

        var db: OpaquePointer?

        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        } else {
            print("Database has been created with path \(filePath)")
            return db
        }
    }

    /**
     Creates PendingTask table if does not exist
     */
    private func createPendingTaskTable() {
        let query = """
                    CREATE TABLE IF NOT EXISTS \(PendingTaskConstants.TABLE_NAME)
                    (\(PendingTaskConstants.ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                    \(PendingTaskConstants.ATTEMPTS) INTEGER,
                    \(PendingTaskConstants.DATE_CREATED) LONG,
                    \(PendingTaskConstants.DATA) TEXT,
                    \(PendingTaskConstants.LAST_ATTEMPTED) LONG,
                    \(PendingTaskConstants.TYPE) TEXT);
                    """
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table creation success")
            } else {
                print("Table creation fail")
            }
        } else {
            print("Preparation fail")
        }
    }
}
