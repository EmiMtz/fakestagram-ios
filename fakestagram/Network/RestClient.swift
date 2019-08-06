//
//  RestClient.swift
//  fakestagram
//
//  Created by LuisE on 3/24/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

class RestClient<T> where T: Codable {
    let client: Client
    let path: String
    typealias codableResponse = (T) -> Void

    init(client: Client, path: String) {
        self.client = client
        self.path = path
    }

    func show(success: @escaping codableResponse) {
        request("GET", path: "\(path)", payload: nil, success: success, errorHandler: nil)
    }

    func show(id: Int, success: @escaping codableResponse) {
        show(id: "\(id)", success: success)
    }
    func show(id: String, success: @escaping codableResponse) {
        request("GET", path: "\(path)/\(id)", payload: nil, success: success, errorHandler: nil)
    }

    func create(codable: T, success: @escaping codableResponse) {
        request("POST", path: "\(path)", payload: codable, success: success, errorHandler: nil)
    }

    func update(id: Int, codable: T, success: @escaping codableResponse) {
        update(id: "\(id)", codable: codable, success: success)
    }
    func update(id: String, codable: T, success: @escaping codableResponse) {
        request("PATCH", path: "\(path)/\(id)", payload: codable, success: success, errorHandler: nil)
    }

    func destroy(id: Int, success: @escaping codableResponse) {
        destroy(id: "\(id)", success: success)
    }
    func destroy(id: String, success: @escaping codableResponse) {
        request("DELETE", path: "\(path)/\(id)", payload: nil, success: success, errorHandler: nil)
    }

    func request(_ method: String, path: String, payload: T?, success: codableResponse?, errorHandler: errorHandler?) {
        request(method, path: path, queryItems: nil, payload: payload, success: success, errorHandler: errorHandler)
    }
    
    func request(_ method: String, path: String, queryItems: [String: String]?, payload: T?, success: codableResponse?, errorHandler: errorHandler?) {
        let data = encode(payload: payload)
        client.request(method, path: path, body: data, completionHandler: { (response, data) in
            guard response.successful() else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                guard let data = data else { print("Empty response"); return }
                let json = try decoder.decode(T.self, from: data)
                success?(json)
            } catch let err {
                print("Unable to parse successfull response: \(err.localizedDescription)")
                errorHandler?(err)
            }
        }, errorHandler: errorHandler)
    }

    private func encode(payload: T?) -> Data? {
        guard let payload = payload else { return nil }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try? encoder.encode(payload)
    }
}
