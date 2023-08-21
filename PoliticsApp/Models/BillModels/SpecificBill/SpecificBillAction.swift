//
//  SpecificBillAction.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/7/23.
//

import Foundation

struct SpecificBillAction: Codable, Identifiable {
    let id: Int
    let chamber: String
    let actionType: String
    let datetime, description: String

    enum CodingKeys: String, CodingKey {
        case id, chamber
        case actionType = "action_type"
        case datetime, description
    }
}
