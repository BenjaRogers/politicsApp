//
//  SpecificMemberViewModel.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/19/23.
//

import Foundation

class SpecificMemberViewModel: ObservableObject {
    
    @Published var member: SpecificMember
    @Published var memberRecentBills: [SponsoredBill]
    @Published var isLoadingPage = false
    @Published var loadView = false
    
    private var canLoadMorePages = true
    private var currentPage = 1
    private var memberID: String
    
    init(memberID: String) {
        let specificMember = ProPublicaAPI().fetchAPIMemberSpecific(memberID: memberID)!.results.first!
        let memberRecentBillResponse = ProPublicaAPI().fetchAPIMemberRecentBills(memberID: memberID, offset: 0)?.results.first!.bills
        
        self.memberID = memberID
        self.member = specificMember
        self.memberRecentBills = memberRecentBillResponse!
    }
    
    func updateSpecificMember(memberID: String) {
        self.memberID = memberID
        self.member = ProPublicaAPI().fetchAPIMemberSpecific(memberID: memberID)!.results.first!
        self.memberRecentBills = (ProPublicaAPI().fetchAPIMemberRecentBills(memberID: memberID, offset: 0)?.results.first!.bills)!
        self.loadView = true
    }
    
    func loadMoreContentIfNeeded(currentItem bill: SponsoredBill?) {
      guard let bill = bill else {
        loadMoreContent()
        return
      }

      let thresholdIndex = memberRecentBills.index(memberRecentBills.endIndex, offsetBy: -5)
      if memberRecentBills.firstIndex(where: { $0.id == bill.id }) == thresholdIndex {
        loadMoreContent()
      }
    }
    
    // Call API for next set of data. Offset must increment by multiple of 20**
    private func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
          return
        }

        isLoadingPage = true
        let bills = ProPublicaAPI().fetchAPIMemberRecentBills(memberID: memberID, offset: self.currentPage * 20)?.results.first!.bills
        for bill in bills! {
            self.memberRecentBills.append(bill)
        }
        self.isLoadingPage = false
        self.currentPage += 1
      }
}
