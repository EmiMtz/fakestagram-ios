//
//  StorageType.swift
//  fakestagram
//
//  Created by LuisE on 3/25/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

enum StorageType {
    case cache
    case permanent

    var searchPathDirectory: FileManager.SearchPathDirectory {
        switch self {
        case .cache: return .cachesDirectory
        case .permanent: return .documentDirectory
        }
    }

    var url: URL {
        var url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first!
        let subfolder = "com.3zcurdia.fakestagram.storage"
        url.appendPathComponent(subfolder)
        return url
    }

    var path: String {
        return url.path
    }

    func clearStorage() {
        try? FileManager.default.removeItem(at: url)
    }

    func ensureExists() {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue { return }
            try? fileManager.removeItem(at: url)
        }
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
    }
}
