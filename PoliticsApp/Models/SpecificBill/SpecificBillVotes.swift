//
//  SpecificBillVotes.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/7/23.
//

import Foundation

struct SpecificBillVote: Codable {
    let chamber: String
    let date, time, rollCall, question: String
    let result: String
    let totalYes, totalNo, totalNotVoting: Int
    let apiURL: String

    enum CodingKeys: String, CodingKey {
        case chamber, date, time
        case rollCall = "roll_call"
        case question, result
        case totalYes = "total_yes"
        case totalNo = "total_no"
        case totalNotVoting = "total_not_voting"
        case apiURL = "api_url"
    }
}
