//
//  SpecificMemberSubcommittee.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/19/23.
//

import Foundation

struct SpecificMemberSubcommittee: Codable, Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let parent_committee_id: String
    let side: String?
    let title: String?
    let rank_in_party: Int?
    let begin_date: String
    let end_date: String
}
