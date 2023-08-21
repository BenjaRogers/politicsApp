//
//  SearchMembersViewModel.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/17/23.
//

import Foundation

class SearchMembersViewModel: ObservableObject {
    
    @Published var membersResults: MembersAllResults
    @Published var members: [Member]
    @Published var member: Member?
    
    @Published var congressSession: Int
    @Published var chamber: String
    
    var membersAll: MembersAll?
    
    init(congressSession: Int, chamber: String) {
        let membersAllResponse = ProPublicaAPI().fetchAPIMembersAll(congressSession: congressSession, chamber: chamber)
        
        self.membersAll = membersAllResponse
        self.membersResults = membersAllResponse!.results.first!
        self.members = membersAllResponse!.results.first!.members
        self.congressSession = congressSession
        self.chamber = chamber
    }
}
