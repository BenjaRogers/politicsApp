//
//  SponsoredBills.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/20/23.
//

import Foundation

struct SponsoredBillsResponse: Codable {
    let status: String
    let results: [SponsoredBillsResults]
}
