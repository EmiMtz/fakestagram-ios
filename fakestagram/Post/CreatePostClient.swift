//
//  CreatePostClient.swift
//  fakestagram
//
//  Created by Emiliano Alfredo Martinez Vazquez D3 on 4/27/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation
import CoreLocation

struct CreatePostBase64: Codable {
    let title: String
    let imageData: String
    let latitude: Double?
    let longitude: Double?
}

class CreatePostClient {

   private let client = Client ()
   private let path = "/api/posts"
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
        
    }()
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
//    init (){}
//    
//    func create(title:String, imageData: String, location: CLLocation?, succes onSuccess: @escaping (Post) -> Void){
//        let payload = CreatePostBase64(title: title, imageData: imageData, latitude: location?.coordinate.latitude, longitude: location?.coordinate.longitude)
//        create(payload: payload, success: onSuccess)
//    }
    
    func create(title: String, imageData: String, location: CLLocation?, succcess onSuccess: @escaping (Post) -> Void) {
        let payload = CreatePostBase64(title: title, imageData: imageData, latitude: location?.coordinate.latitude, longitude: location?.coordinate.longitude)
        create(payload: payload, success: onSuccess)
    }
    
    
    func create(payload: CreatePostBase64, success: @escaping (Post) -> Void) {
        guard let data = try? encoder.encode(payload) else {return}
        
        client.request("POST", path: path, body: data, completionHandler: {(response, data) in
            
            if response.successful (){
                guard let data = data else {
                    print ("Empty data response")
                    return
                }
                do {
                    let json = try self.decoder.decode(Post.self, from: data)
                    success(json)
                } catch let err {
                    print ("Error on serialization: \(err.localizedDescription)")
                }
    } else {
       print("Error on response: \(response.rawResponse) - \(response.status)\n\tBody:\( String(describing: data))")
        }
    }, errorHandler: onError(error:))
    }
        
    private func onError(error: Error?)-> Void{
        guard let err = error else {return}
        print("Error on request: \(err.localizedDescription)")
    }
}
