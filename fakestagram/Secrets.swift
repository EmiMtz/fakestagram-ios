//
//  Secrets.swift
//  fakestagram
//
//  Created by LuisE on 3/17/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation
import SAMKeychain

//return UserDefaults.standard.string(forKey: "com.3zcurdia.fakestagram.uuid")

enum Secrets {
    static let account = "com.3zcurdia.fakestagram"
    case host
    case token

    var value: String? {
        switch self {
        case .host:
            return "https://fakestagram-api.herokuapp.com/"
        case .token:
            return SAMKeychain.password(forService: "authentication", account: Secrets.account)
        }
    }

    func set(value: String) -> Bool {
        switch self {
        case .token:
            SAMKeychain.setPassword(value, forService: "authentication", account: Secrets.account)
            return true
        default:
            return false
        }
    }
}
