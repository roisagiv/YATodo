//
//  TodoRepositorySpec.swift
//  YATodo
//
//  Created by Roi Sagiv on 23/03/2018.
// Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Nimble
import Quick
import GRDB
import RxSwift
import RxBlocking
import OHHTTPStubs
@testable import YATodo

class TodoRepositorySpec: QuickSpec {
  override func spec() {
    describe("all") {

      beforeEach {
        OHHTTPStubs.onStubMissing {
          fail("\($0.url?.absoluteString ?? "") was not stubbed")
        }
      }

      it("saves the todos to the storage") {
        // Arrange
        var httpCalled = 0
        OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos"}) { _ in
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
        OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos"}) { _ in
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
        OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos"}) { _ in
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

      afterEach {
        OHHTTPStubs.removeAllStubs()
      }
    }
  }
}
