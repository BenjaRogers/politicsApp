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
    
    private var canLoadMorePages = true
    private var currentPage = 1
    
    init(recentResults: RecentResults) {
        self.recentResults = recentResults
        self.bills = recentResults.bills
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
        guard !isLoadingPage && canLoadMorePages else {
          return
        }

        isLoadingPage = true
        let data = ProPublicaAPI().fetchAPIBillsSearchData(query: "", pageNum: currentPage)!
        let results = data.results.first!
        for bill in results.bills {
            self.bills.append(bill)
        }
        self.isLoadingPage = false
        self.currentPage += 1
      }
}
