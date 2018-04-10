//
//  TODOModel.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB

public struct TodoModel: Codable {
  // swiftlint:disable:next identifier_name
  let id: Int
  let title: String
  let completed: Bool

  public enum TodoKeys: String, CodingKey {
    // swiftlint:disable:next identifier_name
    case id
    case title
    case completed
  }
}

extension TodoModel: RowConvertible, Persistable, TableMapping {
  public static var databaseTableName: String = "todos"

  enum Columns {
    // swiftlint:disable:next identifier_name
    static let id = Column(TodoModel.TodoKeys.id.rawValue)
    static let title = Column(TodoModel.TodoKeys.title.rawValue)
    static let completed = Column(TodoModel.TodoKeys.completed.rawValue)
  }
}
