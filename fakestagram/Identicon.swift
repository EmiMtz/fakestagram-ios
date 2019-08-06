//
//  Identicon.swift
//  fakestagram
//
//  Created by LuisE on 3/16/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

struct Identicon {
    let key: String

    func url() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "cutenizer.herokuapp.com"
        urlComponents.path = "/identicon.svg"
        urlComponents.queryItems = [URLQueryItem(name: "key", value: self.key)]

        return urlComponents.url
    }
}
