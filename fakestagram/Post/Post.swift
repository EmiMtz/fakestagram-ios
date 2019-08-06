//
//  Post.swift
//  fakestagram
//
//  Created by LuisE on 3/16/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation
import UIKit

struct Post: Codable {
    let id: Int?
    let title: String
    let imageUrl: String?
    let author: Author?
    var likesCount: Int
    let commentsCount: Int
    let createdAt: String
    var liked : Bool
    let latitude: Float?
    let longitude: Float?
    let location: String
    
//    mutating func swapLiked() -> Bool{
//        self.liked = !self.liked
//        return self.liked
//    }
    
    func likesCountText() -> String {
        return "\(likesCount) likes"
    }
    
    func commentsCountText() -> String {
        return "\(commentsCount) comments"
    }
    
    func load(_ image: @escaping (UIImage) -> Void) {
        let cache = ImageCache(filename: "image-\(self.id!).jpg")
        if let img = cache.load() {
            image(img)
            return
        }
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                DispatchQueue.main.async { image(img) }
                _ = cache.save(image: img)
            }
        }
    }
}

//
//import Foundation
//import UIKit
//
//struct Post: Codable {
//    let id: Int?
//    let title: String
//    let imageUrl: String?
//    let author: Author?
//    let likesCount: Int
//    let commentsCount: Int
//    let createdAt: String
//
//    func load(_ image: @escaping (UIImage) -> Void) {
//        let cache = ImageCache(filename: "image-\(self.id!).jpg")
//        if let img = cache.load() {
//            image(img)
//            return
//        }
//        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
//        DispatchQueue.global(qos: .background).async {
//            if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
//                DispatchQueue.main.async { image(img) }
//                _ = cache.save(image: img)
//            }
//        }
//    }
//}

