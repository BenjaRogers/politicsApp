//
//  Vote.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/10/23.
//

import Foundation

struct SpecificRollCallVote: Codable, Identifiable {
    let id = UUID()
    let result: String
    let date: String
    var positions: [Position]? = []
}

struct Democratic: Codable {
    let yes: Int
    let no: Int
    let present: Int
    let not_voting: Int
    let majority_position: String
}

struct Republican: Codable {
    let yes: Int
    let no: Int
    let present: Int
    let not_voting: Int
    let majority_position: String
}
