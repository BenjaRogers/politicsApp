//
//  SpecificMember.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/19/23.
//

import Foundation

struct SpecificMember: Codable {
    let id: String
    let first_name: String
    let middle_name: String?
    let last_name: String
    var full_name: String {
        return "\(first_name) \(last_name)"
    }
    let suffix: String?
    let date_of_birth: String
    let gender: String
    let url: String?
    let twitter_account: String?
    let face_book_account: String?
    let youtube_account: String?
    let in_office: Bool
    let current_party: String?
    let most_recent_vote: String
    let last_updated: String
    let roles: [SpecificMemberRole]
}
