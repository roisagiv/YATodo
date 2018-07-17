//
//  TODOModel.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB

public struct TodoModel: Codable {
  let id: Int
  let title: String
  let completed: Bool

  public enum TodoKeys: String, CodingKey {
    case id
    case title
    case completed
  }
}

extension TodoModel: FetchableRecord, PersistableRecord, TableRecord {
  public static var databaseTableName: String = "todos"

  struct Columns: ColumnExpression {
    var name: String

    static let id = Column(TodoModel.TodoKeys.id.rawValue)
    static let title = Column(TodoModel.TodoKeys.title.rawValue)
    static let completed = Column(TodoModel.TodoKeys.completed.rawValue)
  }
}
