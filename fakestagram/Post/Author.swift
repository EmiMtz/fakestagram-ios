//
//  Author.swift
//  fakestagram
//
//  Created by LuisE on 3/16/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

struct Author: Codable {
    let id: String
    let name: String

    func avatarUrl() -> URL {
        return Identicon(key: self.name).url()!
    }
}
