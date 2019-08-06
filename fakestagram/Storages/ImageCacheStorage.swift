//
//  ImageCacheStorage.swift
//  fakestagram
//
//  Created by LuisE on 4/25/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheStorage {
    static let shared = ImageCacheStorage()
    private let cache = NSCache<NSString, UIImage>()
    private let storageType = StorageType.cache

    init() {
        storageType.ensureExists()
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        let url = imageURL(forKey: key)

        if let data = image.jpegData(compressionQuality: 0.95) {
            try? data.write(to: url, options: [.atomic])
        }
    }

    func getImage(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }

        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }

        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }

    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)

        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }

    private func imageURL(forKey key: String) -> URL {
        var directory = storageType.url
        directory.appendPathComponent(key)
        return directory
    }

}
