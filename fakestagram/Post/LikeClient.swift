//
//  LikeClient.swift
//  fakestagram
//
//  Created by Emiliano Alfredo Martinez Vazquez D3 on 4/27/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

class LikeUpdaterClient{
    private let client = Client()
    private let basePath = "/api/posts"
    private let post: Post
    private let row: Int
    
    init(post: Post, row: Int){
        self.post = post
        self.row = row
    }
    
    func call() -> Post {
        if !post.liked {
            return like()
        } else {
            return dislike()
        }
    }
    
    func like() -> Post {
        var post = self.post
        guard let postId = post.id else { return post }
        client.request("POST", path: "\(basePath)/\(postId)/like", body: nil, completionHandler: onSuccessLike (response:data:), errorHandler: onError(error:))
        post.likesCount += 1
        post.liked = true
        return post
    }
    
    func dislike() -> Post{
        var post = self.post
        guard let postId = post.id else { return post }
        client.request("DELETE", path: "\(basePath)/\(postId)/like", body: nil, completionHandler: onSuccessDislike (response:data:), errorHandler: onError(error:))
        post.likesCount -= 1
        post.liked = false
        return post
    }
    
    func onSuccessLike (response: HTTPResponse, data: Data?){
        guard response.successful() else { return }
        var post = self.post
        post.likesCount += 1
        post.liked = true
        sendNotification(for: post)
    }
    
    
    func onSuccessDislike (response: HTTPResponse, data: Data?){
        guard response.successful() else { return }
        var post = self.post
        post.likesCount -= 1
        post.liked = true
        sendNotification(for: post)
    }
    
    private func onError(error: Error?){
        guard let err = error else { return }
        print("Error on request: \(err.localizedDescription)")
    }
    
    func sendNotification(for updatedPost: Post){
        guard let data = try? JSONEncoder().encode(updatedPost) else { return }
        NotificationCenter.default.post(name: .didLikePost, object: nil, userInfo: ["post" : data as Any, "row": row as Any])
    }
}


//class LikeClient {
//    private let client = Client()
//    private let path = "/api/posts"
//    
//    
//    func like(post: Post) -> Int {
//        guard let postId = post.id else { return post.likesCount }
//        client.request("POST", path: "\(basePath)/\(postId)/like", body: nil, completionHandler: onSuccess(response:data:), errorHandler: onError(error:))
//        return post.likesCount + 1
//
//    }
//    func dislike(post: Post) -> Int{
//        guard let postId = post.id else { return post.likesCount}
//        client.request("DELETE", path: "\(basePath)/\(postId)/like", body: nil, completionHandler: onSuccess(response:data:), errorHandler: onError(error:))
//        return post.likesCount - 1
//    }
//    
//    func onSuccess(response: HTTPResponse, data: Data?)-> Void{
//        guard response.successful() else {return}
//        print("Yeaaaa!")
//    }
//    
//    private func onError(error)
//}
