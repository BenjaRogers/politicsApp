//
//  SpecificMemberRole.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/19/23.
//

import Foundation

struct SpecificMemberRole: Codable, Identifiable {
    let id = UUID()
    let congress: String
    let chamber: String
    let title: String
    let short_title: String
    let state: String
    let party: String
    let leadership_role: String?
    let seniority: String
    let senate_class: String
    let state_rank: String
    let start_date: String
    let end_date: String
    let office: String?
    let phone: String?
    let contact_form: String?
    let cook_pvi: String?
    let dw_nominate: Double?
    let ideal_point: Double?
    let next_election: String?
    let total_votes: Int
    let missed_votes: Int
    let total_present: Int
    let bills_sponsored: Int
    let bills_cosponsored: Int
    let missed_votes_pct: Double
    let votes_with_party_pct: Double
    let votes_against_party_pct: Double
    let committees: [SpecificMemberCommittee]?
    let subcommittees: [SpecificMemberSubcommittee]?
}
