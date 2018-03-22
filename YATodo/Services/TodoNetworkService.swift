//
//  TodoNetworkService.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Moya
import RxSwift

protocol TodoNetworkService {
  func all() -> Single<[TodoModel]>
}

struct MoyaTodoNetworkService: TodoNetworkService {
  private let provider: MoyaProvider<JsonPlaceHolderAPI>

  init(log: Bool) {
    var plugins: [PluginType] = []
    if log {
      plugins.append(NetworkLoggerPlugin(verbose: true, cURL: true))
    }

    provider = MoyaProvider<JsonPlaceHolderAPI>(plugins: plugins)
  }

  func all() -> Single<[TodoModel]> {
    return provider.rx
      .request(.all)
      .filterSuccessfulStatusAndRedirectCodes()
      .map([TodoModel].self)
  }
}
