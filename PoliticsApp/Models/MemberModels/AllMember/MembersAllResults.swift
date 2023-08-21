//
//  MembersAllResults.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/17/23.
//

import Foundation

struct MembersAllResults: Codable {
    var congress: String
    var chamber: String
    var members: [Member]
}
