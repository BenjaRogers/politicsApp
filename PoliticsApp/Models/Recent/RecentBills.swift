//
//  UpcomingBills.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/5/23.
//

import Foundation
// Parent model to hold multiple RecentBill objects
// JSON source goes RecentBills -> [RecentResults] -> [RecentBill]
struct RecentBills: Codable {
    let results: [RecentResults]
}
