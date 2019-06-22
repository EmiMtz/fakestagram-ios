//
//  Like.swift
//  fakestagram
//
//  Created by Emiliano Alfredo Martinez Vazquez D3 on 4/27/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

struct Like: Codable {
    let author : Author?
    let createdAt: String
    let updatedAt: String
}
