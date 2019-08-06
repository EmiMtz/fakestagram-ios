//
//  Name.swift
//  fakestagram
//
//  Created by LuisE on 3/17/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

struct Names {
    let maleFirstNames: [String]
    let femaleFirstNames: [String]
    let lastNames: [String]

    static func load() -> Names {
        let filePath = Bundle.main.path(forResource: "Names", ofType: "plist")!
        let namesDic = NSDictionary(contentsOfFile: filePath)!["names"]! as! NSDictionary

        let maleFirstNames = namesDic["male_first_name"] as! [String]
        let femaleFirstNames = namesDic["female_first_name"] as! [String]
        let lastNames = namesDic["last_name"] as! [String]

        return Names(maleFirstNames: maleFirstNames, femaleFirstNames: femaleFirstNames, lastNames: lastNames)
    }

    func firstNames() -> [String] {
        return femaleFirstNames+maleFirstNames
    }

    func generate() -> String {
        return "\(firstNames().randomElement()!) \(lastNames.randomElement()!)"
    }
}
