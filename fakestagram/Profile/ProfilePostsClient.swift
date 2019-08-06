//
//  ProfilePostsClient.swift
//  fakestagram
//
//  Created by Emiliano Alfredo Martinez Vazquez D3 on 5/4/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

class ProfilePostsClient: RestClient<[Post]> {
    convenience init(){
        self.init(client: Client(), path: "/api/profile/posts")
    }
}
