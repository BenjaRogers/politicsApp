//
//  CosponsorsParty.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/5/23.
//

import Foundation

struct CosponsorsParty: Codable {
    let d, r, id: Int?
    enum CodingKeys: String, CodingKey {
        case d = "D"
        case r = "R"
        case id = "ID"
    }
}
