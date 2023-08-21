//
//  SponsoredBillsResults.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/20/23.
//

import Foundation

struct SponsoredBillsResults: Codable {
    let id: String
    let name: String
    let num_results: Int
    let offset: Int
    let bills: [SponsoredBill]
}
