//
//  SpecificVote.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/10/23.
//

import Foundation

struct Position: Codable, Identifiable, Equatable, Hashable {
    let id = UUID()
    let member_id: String?
    let name: String?
    let party: String?
    let state: String?
    let district: String?
    let vote_position: String?
}
