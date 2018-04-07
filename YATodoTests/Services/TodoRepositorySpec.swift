//
//  TodoRepositorySpec.swift
//  YATodo
//
//  Created by Roi Sagiv on 23/03/2018.
// Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB
import Nimble
import OHHTTPStubs
import Quick
import RxBlocking
import RxSwift
@testable import YATodo

class TodoRepositorySpec: QuickSpec {
  override func spec() {
    describe("repository") {

      beforeEach {
        OHHTTPStubs.onStubMissing {
          fail("\($0.url?.absoluteString ?? "") was not stubbed")
        }
      }

      afterEach {
        OHHTTPStubs.removeAllStubs()
      }

      describe("all") {

        it("saves the todos to the storage") {
          // Arrange
          var httpCalled = 0
          OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos" }) { _ in
            httpCalled += 1
            let path = OHPathForFile("jsonplaceholder-todos-success.json", TodoRepositorySpec.self)!
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
          }

          let db = DatabaseQueue()
          try! DBMigrationService.migrate(database: db)

          let network = MoyaTodoNetworkService(log: false)
          let storage = GRDBTodoStorageService(database: db)
          let repo = TodoRepository(storage: storage, network: network)

          // Act & Assert
          expect { try repo.all().toBlocking().first() }.to(haveCount(200))
          expect(httpCalled).to(equal(1))
          db.inDatabase { database in
            expect(try! TodoModel.fetchCount(database)).to(equal(200))
          }
        }

        it("throws if network error") {
          // Arrange
          var httpCalled = 0
          OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos" }) { _ in
            httpCalled += 1
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
            return OHHTTPStubsResponse(error: notConnectedError)
          }

          let db = DatabaseQueue()
          try! DBMigrationService.migrate(database: db)

          let network = MoyaTodoNetworkService(log: false)
          let storage = GRDBTodoStorageService(database: db)
          let repo = TodoRepository(storage: storage, network: network)

          // Act & Assert
          expect { try repo.all().toBlocking().first() }.to(throwError())
          expect(httpCalled).to(equal(1))
          db.inDatabase { database in
            expect(try! TodoModel.fetchCount(database)).to(equal(0))
          }
        }

        it("calls the nework only once") {
          // Arrange
          var httpCalled = 0
          OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos" }) { _ in
            httpCalled += 1
            let path = OHPathForFile("jsonplaceholder-todos-success.json", TodoRepositorySpec.self)!
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
          }

          let db = DBFactory.inMemory(log: false)
          try! DBMigrationService.migrate(database: db)

          let network = MoyaTodoNetworkService(log: false)
          let storage = GRDBTodoStorageService(database: db)
          let repo = TodoRepository(storage: storage, network: network)

          // Act & Assert
          expect { try repo.all().toBlocking().first() }.to(haveCount(200))
          expect { try repo.all().toBlocking().first() }.to(haveCount(200))
          expect { try repo.all().toBlocking().first() }.to(haveCount(200))
          expect(httpCalled).to(equal(1))
        }

      }

      describe("get") {

        it("return stored todo") {
          let todoId = 1

          OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos/\(todoId)" }) { _ in
            fail("Should not call HTTP")
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
            return OHHTTPStubsResponse(error: notConnectedError)
          }

          let db = DBFactory.inMemory(log: false)
          try! DBMigrationService.migrate(database: db)

          let network = MoyaTodoNetworkService(log: false)
          let storage = GRDBTodoStorageService(database: db)
          let repo = TodoRepository(storage: storage, network: network)

          expect { try storage.save(todos: [
            TodoModel(id: todoId, title: "title", completed: false)
          ]).toBlocking().first() }.to(haveCount(1))

          expect { try repo.get(id: todoId).toBlocking().first()?.id }.to(equal(1))
        }

        it("performs network call if not in storage") {
          let todoId = 2

          var httpCalled = 0
          OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos/\(todoId)" }) { _ in
            httpCalled += 1
            let path = OHPathForFile("jsonplaceholder-get-success.json", TodoRepositorySpec.self)!
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
          }

          let db = DBFactory.inMemory(log: false)
          try! DBMigrationService.migrate(database: db)

          let network = MoyaTodoNetworkService(log: false)
          let storage = GRDBTodoStorageService(database: db)
          let repo = TodoRepository(storage: storage, network: network)

          expect { try storage.save(todos: [
            TodoModel(id: todoId + 1, title: "title", completed: false)
          ]).toBlocking().first() }.to(haveCount(1))

          expect { try repo.get(id: todoId).toBlocking().first()?.id }.to(equal(100))
          expect(httpCalled).to(equal(1))
        }
      }

      describe("save") {
        it("performs `update` network call and than save to storage") {
          let todo = TodoModel(id: 100, title: "title 1", completed: true)
          var httpCalled = 0

          OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos/\(todo.id)" }) { request in
            expect(request.httpMethod).to(equal("PUT"))
            httpCalled += 1
            return OHHTTPStubsResponse(data: JSONs.toData(todo), statusCode: 200, headers: nil)
          }

          let db = DBFactory.inMemory(log: false)
          try! DBMigrationService.migrate(database: db)

          let network = MoyaTodoNetworkService(log: false)
          let storage = GRDBTodoStorageService(database: db)
          let repo = TodoRepository(storage: storage, network: network)

          // before
          expect { try storage.all().toBlocking().first()?.count }.to(equal(0))

          expect { try repo.save(todo: todo).toBlocking().first()?.id }.to(equal(todo.id))

          // after
          expect { try storage.all().toBlocking().first()?.count }.to(equal(1))
          expect { try storage.get(id: todo.id).toBlocking().first()??.title }.to(equal(todo.title))
          expect(httpCalled).to(equal(1))
        }

        it("performs `create` network call and than save to storage") {
          let todo = TodoModel(id: 0, title: "title 1", completed: true)
          let idFromServer = 100
          var httpCalled = 0

          OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos" }) { request in
            expect(request.httpMethod).to(equal("POST"))
            httpCalled += 1
            let payload = TodoModel(id: idFromServer, title: todo.title, completed: todo.completed)
            return OHHTTPStubsResponse(data: JSONs.toData(payload), statusCode: 200, headers: nil)
          }

          let db = DBFactory.inMemory(log: false)
          try! DBMigrationService.migrate(database: db)

          let network = MoyaTodoNetworkService(log: false)
          let storage = GRDBTodoStorageService(database: db)
          let repo = TodoRepository(storage: storage, network: network)

          // before
          expect { try storage.all().toBlocking().first()?.count }.to(equal(0))

          expect { try repo.save(todo: todo).toBlocking().first()?.id }.to(equal(idFromServer))

          // after
          expect { try storage.all().toBlocking().first()?.count }.to(equal(1))
          expect { try storage.get(id: idFromServer).toBlocking().first()??.title }.to(equal(todo.title))
          expect(httpCalled).to(equal(1))
        }
      }

      describe("toggle") {

        it("toggles the completed field in db") {
          let todo = TodoModel(id: 1, title: "title", completed: false)
          var httpCalled = 0
          OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos/\(todo.id)" }) { request in
            expect(request.httpMethod).to(equal("PUT"))
            httpCalled += 1
            return OHHTTPStubsResponse(data: JSONs.toData(todo), statusCode: 200, headers: nil)
          }
          let db = DBFactory.inMemory(log: false)
          try! DBMigrationService.migrate(database: db)

          let storage = GRDBTodoStorageService(database: db)
          let network = MoyaTodoNetworkService(log: false)
          let repo = TodoRepository(storage: storage, network: network)

          expect { try repo.save(todo: todo).toBlocking().first()?.completed }.to(equal(todo.completed))

          expect { try repo.get(id: todo.id).toBlocking().first()?.completed }.to(equal(todo.completed))
          expect { try repo.toggle(todo: todo).toBlocking().first() }.notTo(throwError())
          expect { try repo.get(id: todo.id).toBlocking().first()?.completed }.to(equal(!todo.completed))
          expect(httpCalled).to(equal(2))
        }
      }

      describe("delete") {

        it("sends DELETE request") {
          let todo = TodoModel(id: 1, title: "title", completed: true)
          var httpCalled = 0
          OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos/\(todo.id)" }) { request in
            expect(request.httpMethod).to(equal("DELETE"))
            httpCalled += 1
            return OHHTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
          }

          let db = DBFactory.inMemory(log: false)
          try! DBMigrationService.migrate(database: db)
          db.inDatabase { database in
            try! todo.insert(database)
          }

          let storage = GRDBTodoStorageService(database: db)
          let network = MoyaTodoNetworkService(log: false)
          let repo = TodoRepository(storage: storage, network: network)

          expect { try storage.all().toBlocking().first()?.count }.to(equal(1))
          expect { try repo.delete(id: todo.id).toBlocking().first() }.notTo(throwError())
          expect(httpCalled).to(equal(1))
          expect { try storage.all().toBlocking().first()?.count }.to(equal(0))
        }
      }
    }
  }
}
