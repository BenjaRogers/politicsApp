//
//  SpecificBill.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/7/23.
//

import Foundation

struct Action: Codable {
    let id: Int
    let chamber, action_type, datetime, description: String
}

struct SpecificBill: Codable, Identifiable {
    let id = 1
    let bill_id, bill_slug, congress, bill: String
    let bill_type, number: String
    let bill_uri: String
    let title, short_title, sponsor_title, sponsor: String
    let sponsor_id: String
    let sponsor_uri: String
    let sponsor_party, sponsor_state: String
    let congressdotgov_url, govtrack_url: String
    let introduced_date: String
    let active: Bool
    let last_vote, house_passage, senate_passage, enacted: String?
    let vetoed: String?
    let cosponsors: Int
    let cosponsors_by_party: CosponsorsParty
    let withdrawn_cosponsors: Int
    let primary_subject, committees: String
    let committee_codes, subcommittee_codes: [String]
    let latest_major_action_date, latest_major_action: String
    let house_passage_vote, senate_passage_vote: String?
    let summary, summary_short: String
    let actions: [SpecificBillAction]
    let presidential_statements: [String?]
    let votes: [SpecificBillVote]
    
    func getCosponsorString() -> String {
        var dNum: Int = 0
        var rNum: Int = 0
        var idNum: Int = 0
        
        if cosponsors_by_party.d != nil {
            dNum = cosponsors_by_party.d!
        }
        if cosponsors_by_party.r != nil {
            rNum = cosponsors_by_party.r!
        }
        if cosponsors_by_party.id != nil {
            idNum = cosponsors_by_party.id!
        }
        return "D:\(dNum) R:\(rNum) ID:\(idNum)"
    }
}

