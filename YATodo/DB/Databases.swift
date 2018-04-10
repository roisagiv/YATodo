//
//  Databases.swift
//  YATodo
//
//  Created by Roi Sagiv on 24/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB

struct Databases {

  static func inMemory(log: Bool) -> DatabaseQueue {
    var configuration = Configuration()
    if log {
      configuration.trace = { print("SQL: \($0)") }
    }
    return DatabaseQueue(configuration: configuration)
  }

  static func migrate(database: DatabaseWriter) throws {
    try migrator.migrate(database)
  }

  private static var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()

    migrator.registerMigration("v1.0") { database in
      try database.create(table: TodoModel.databaseTableName) { table in
        table.column(TodoModel.Columns.id.name, .integer).primaryKey()
        table.column(TodoModel.Columns.title.name, .text).notNull().collate(.localizedCaseInsensitiveCompare)
        table.column(TodoModel.Columns.completed.name, .boolean).defaults(to: false)
      }
    }

    return migrator
  }
}
