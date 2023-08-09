//
//  DateDiffCalc.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/6/23.
//

import Foundation

// Calculate number of days from dateposted to current time (excludes first day)
// Might want to get more granular with this down to hr's since update?
// used in BillRowView -> FeedView for bill header to show how long ago the update happened.
extension Calendar {
    func dateDiffCalc(datePosted: String) -> Int {
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "y-MM-dd"
        
        // Convert String to Date
        let datePostedDate = dateFormatter.date(from: datePosted)
        
        let fromDate = startOfDay(for: datePostedDate!) // <1>
        let toDate = startOfDay(for: Date.now) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
