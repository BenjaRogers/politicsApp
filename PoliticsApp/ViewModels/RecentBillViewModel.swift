//
//  BillViewModel.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/5/23.
//

import Foundation

// endless scroll instructions: https://www.donnywals.com/implementing-an-infinite-scrolling-list-with-swiftui-and-combine/
class RecentBillViewModel: ObservableObject {
    @Published var recentResults: RecentResults
    @Published var bills: [RecentBill]
    @Published var isLoadingPage = false
    
    @Published var congressSession: Int
    @Published var chamber: String = "both"
    @Published var type: String
    
    private var canLoadMorePages = true
    private var currentPage = 1
    
    init(recentResults: RecentResults, congressSession:Int, chamber: String, type: String) {
        self.recentResults = recentResults
        self.bills = recentResults.bills
        self.congressSession = congressSession
        self.chamber = chamber
        self.type = type
    }
    
    func updateViewModelBills() {
        print("Updating VM")
        let recentBills = ProPublicaAPI().fetchAPIBillsRecent(congressSession: self.congressSession, chamber: self.chamber, type: self.type, pageNum: self.currentPage)!
        self.recentResults = recentBills.results.first!
        self.bills = self.recentResults.bills
    }
    
    func updateViewModelSearchParams(congressSession:Int, chamber: String, type: String) {
        print("Updating VM params")
        self.congressSession = congressSession
        self.chamber = chamber
        self.type = type
        self.currentPage = 0
        self.canLoadMorePages = true
    }
    
    // Load more content from endpoint if scrollview is nearing bottom of loaded results
    func loadMoreContentIfNeeded(currentItem bill: RecentBill?) {
      guard let bill = bill else {
        loadMoreContent()
        return
      }

      let thresholdIndex = bills.index(bills.endIndex, offsetBy: -5)
      if bills.firstIndex(where: { $0.id == bill.id }) == thresholdIndex {
        loadMoreContent()
      }
    }
    
    // Call API for next set of data. Offset must increment by multiple of 20**
    private func loadMoreContent() {
        print("loading more content")
        guard !isLoadingPage && canLoadMorePages else {
          return
        }

        isLoadingPage = true
        let data = ProPublicaAPI().fetchAPIBillsRecent(congressSession: self.congressSession, chamber: self.chamber, type: self.type, pageNum: self.currentPage)!
        let results = data.results.first!
        for bill in results.bills {
            self.bills.append(bill)
        }
        self.isLoadingPage = false
        self.currentPage += 1
        print(self.currentPage)
      }
}
