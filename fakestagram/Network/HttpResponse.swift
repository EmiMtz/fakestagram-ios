//
//  HttpResponse.swift
//  fakestagram
//
//  Created by LuisE on 3/24/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

class HTTPResponse {
    let rawResponse: HTTPURLResponse

    init(reponse: HTTPURLResponse) {
        self.rawResponse = reponse
    }

    lazy var status: Status = {
        return Status(rawValue: self.rawResponse.statusCode)
    }()

    func successful() -> Bool {
        return status == Status.success
    }
}
