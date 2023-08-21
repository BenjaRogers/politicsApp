//
//  memberFilterViewModel.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/20/23.
//

import Foundation

enum MemberFilterViewModel: Int, CaseIterable {
    case sponsor
    case votes
    
    var title: String {
        switch self {
        case .sponsor: return "Sponsor"
        case .votes: return "Votes"
        }
    }
}
