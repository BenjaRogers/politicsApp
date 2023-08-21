//
//  SponsoredBill.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/20/23.
//

import Foundation

struct SponsoredBill: Codable, Identifiable {
    var id: String {return bill_id}
    let congress: String
    let bill_id: String
    var bill_slug: String {
        let idSplit = bill_id.components(separatedBy: "-")
        let billSlug = idSplit[0]
        return billSlug
    }
    let title: String
    let sponsor_title: String
    let sponsor_id: String
    let sponsor_name: String
    let sponsor_state: String
    let sponsor_party: String
    let active: Bool?
    let last_vote: String?
    let house_passage: String?
    let senate_passage: String?
    let enacted: String?
    let vetoed: String?
    let cosponsors: Int?
    let cosponsors_by_party: CosponsorsParty
    let committees: String?
    let primary_subject: String?
    let summary: String?
    let latest_major_action_date: String?
    let latest_major_action: String?
    
    
}
