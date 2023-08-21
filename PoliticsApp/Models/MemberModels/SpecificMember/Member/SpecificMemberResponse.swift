//
//  SpecificMemberResponse.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/19/23.
//

import Foundation

struct SpecificMemberResponse: Codable {
    let status: String
    let results: [SpecificMember]
}
