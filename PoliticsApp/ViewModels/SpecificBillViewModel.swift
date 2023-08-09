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
    
    @Published var showSpecificBillView = false
    @Published var bill: SpecificBill?
    
    init(specificResults: SpecificBills) {
        self.specificResults = specificResults
        self.bills = specificResults.results
        self.bill = bills.first!
        setSenateVoteCount()
        setHouseVoteCount()
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
            }
        }
    }
    
    func setHouseVoteCount() {
        var totalVotes: Int
        
        for vote in self.bill!.votes {
            if vote.chamber == "House" {
                totalVotes = vote.totalYes + vote.totalNo + vote.totalNotVoting
                self.houseVoteCount = [vote.totalYes, vote.totalNo, vote.totalNotVoting, totalVotes]
            }
        }
    }
}
