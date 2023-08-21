//
//  Member.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/17/23.
//

import Foundation

struct Member: Codable, Identifiable {
    let id: String
    let title: String
    let short_title: String
    let api_url: String?
    let first_name: String
    let middle_name: String?
    let last_name: String
    var first_last_name: String {
        return "\(first_name) \(last_name)"
    }
    let date_of_birth: String
    let gender: String
    let party: String
    let leadership_role: String?
    let twitter_account: String?
    let url: String?
    let seniority: String
    let next_election: String?
    let total_votes: Int
    let missed_votes: Int
    let total_present: Int
    let office: String?
    let phone: String?
    let state: String
    let district: String?
    let missed_votes_pct: Double
    let votes_with_party_pct: Double
    let votes_against_party_pct: Double
}
