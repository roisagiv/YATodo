//
//  RouterSpec.swift
//  YATodo
//
//  Created by Roi Sagiv on 01/04/2018.
// Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Nimble
import Quick
@testable import YATodo

class RouterSpec: QuickSpec {
  override func spec() {
    describe("URL mapping") {
      it("should parse URL into list Route") {
        var url = URL(string: "/")!
        var result = Route(url: url)
        expect(result).to(equal(Route.list))

        url = URL(string: "/todos")!
        result = Route(url: url)
        expect(result).to(equal(Route.list))
      }

      it("should parse URL into new Route") {
        let url = URL(string: "/todos/new")!
        let result = Route(url: url)
        expect(result).to(equal(Route.new))
      }

      it("sould parse URL into edit Route") {
        let id = 3456
        let url = URL(string: "/todos/\(id)")!
        let result = Route(url: url)
        expect(result).to(equal(Route.edit(id: id)))
      }
    }
  }
}
