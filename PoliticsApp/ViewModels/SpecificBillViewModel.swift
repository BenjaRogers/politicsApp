//
//  SpecificBillViewModel.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/7/23.
//

import Foundation

class SpecificBillViewModel: ObservableObject {
    private var specificResults: SpecificBills
    private var bills: [SpecificBill] // Single Item array
    
    @Published var senateVoteCount: [Int] = []
    @Published var houseVoteCount: [Int] = []
    @Published var senateVoteResult: String = ""
    @Published var houseVoteResult: String = ""
    @Published var senateVoteDate: String = ""
    @Published var houseVoteDate: String = ""
    
    
    @Published var houseVoteRollCall: [Position] = []
    @Published var senateVoteRollCall: [Position] = []
    
    @Published var showSpecificBillView = false
    @Published var bill: SpecificBill?
    
    
    init(specificResults: SpecificBills) {
        self.specificResults = specificResults
        self.bills = specificResults.results
        self.bill = bills.first!
        setSenateVoteCount()
        setHouseVoteCount()
        setSenateRollCall()
        setHouseRollCall()
    }
    
    func nextSpecificBill(specificResults: SpecificBills) {
        self.specificResults = specificResults
        self.bills = specificResults.results
        self.bill = self.bills.first!
        
    }
    
    func setSenateVoteCount() {
        var totalVotes: Int
        
        for vote in self.bill!.votes {
            if vote.chamber == "Senate" {
                totalVotes = vote.totalYes + vote.totalNo + vote.totalNotVoting
                self.senateVoteCount = [vote.totalYes, vote.totalNo, vote.totalNotVoting, totalVotes]
                self.senateVoteResult = vote.result
                self.senateVoteDate = vote.date
            }
        }
    }
    
    func setHouseVoteCount() {
        var totalVotes: Int
        
        for vote in self.bill!.votes {
            if vote.chamber == "House" {
                totalVotes = vote.totalYes + vote.totalNo + vote.totalNotVoting
                self.houseVoteCount = [vote.totalYes, vote.totalNo, vote.totalNotVoting, totalVotes]
                self.houseVoteResult = vote.result
                self.houseVoteDate = vote.date
            }
        }
    }
    
    func setSenateRollCall() {
        for chamberVotes in bill!.votes {
            if chamberVotes.chamber == "Senate" {
                let specificRollCallVote = ProPublicaAPI().fetchAPIRollCallVoteSpecific(apiUrl: chamberVotes.apiURL)!
                if specificRollCallVote.results != nil {
                    self.senateVoteRollCall = specificRollCallVote.results!.votes!.vote!.positions!
                }
            }
        }
    }
    
    func setHouseRollCall() {
        for chamberVotes in bill!.votes {
            if chamberVotes.chamber == "House" {
                let specificRollCallVote = ProPublicaAPI().fetchAPIRollCallVoteSpecific(apiUrl: chamberVotes.apiURL)!
                if specificRollCallVote.results != nil {
                    self.houseVoteRollCall = specificRollCallVote.results!.votes!.vote!.positions!
                }
            }
        }
    }
}
