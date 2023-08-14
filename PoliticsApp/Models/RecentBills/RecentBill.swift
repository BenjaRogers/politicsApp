//
//  BillUpcoming.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/5/23.
//

import Foundation
import UIKit

struct RecentBill: Codable, Identifiable{
    var id: String {bill_id}
    let bill_id: String
    let bill_slug: String
    let bill_type: String
    let bill_uri: String
    let committee_codes: [String]
    let committees: String
    let congressdotgov_url: String
    let cosponsors: Int
    let cosponsors_by_party: CosponsorsParty
    let enacted: String?
    let govtrack_url: String
    let introduced_date: String
    let last_vote: String?
    let latest_major_action: String
    let latest_major_action_date: String
    let number: String
    let primary_subject: String
    let senate_passage: String?
    let short_title: String
    let sponsor_id: String
    let sponsor_name: String
    let sponsor_party: String
    let sponsor_state: String
    let sponsor_title: String
    let sponsor_uri: String
    let subcomittee_codes: [String]?
    let summary: String
    let summary_short: String
    let title: String
    let vetoed: String?
    
    func getImage() -> UIImage? {
        let url = URL(string: "https://theunitedstates.io/images/congress/225x275/\(self.bill_slug).jpg")
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            return image
        }
        return UIImage()
    }
}
