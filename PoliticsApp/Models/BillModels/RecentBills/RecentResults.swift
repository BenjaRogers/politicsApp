//
//  UpcomingResults.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/5/23.
//

import Foundation

struct RecentResults: Codable, Identifiable {
    let id = 1 //always one result as far as I can tell. This will need to get fixed eventually though... temporary fix for Identifiable protocol
    
    let offset: Int
    let num_results: Int
    let bills: [RecentBill]
}
