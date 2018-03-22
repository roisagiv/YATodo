//
//  DBMigrationService.swift
//  YATodo
//
//  Created by Roi Sagiv on 23/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Fakery
import GRDB

struct DBMigrationService {
  static func migrate(database: DatabaseWriter) throws {
    try migrator.migrate(database)
  }

  static func fill(database: DatabaseWriter) throws {
    try fixtures.migrate(database)
  }

  private static var fixtures: DatabaseMigrator {
    var migrator = DatabaseMigrator()
    migrator.registerMigration("fixtures") { database in
      let fake = Faker()
      for _ in 0..<40 {
        let todo = TodoModel(
          id: fake.number.increasingUniqueId(),
          title: fake.lorem.sentence(),
          completed: fake.number.randomBool()
        )
        try todo.insert(database)
      }

    }
    return migrator
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
