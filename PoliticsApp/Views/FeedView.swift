//
//  FeedView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/5/23.
//

import SwiftUI

// Show recent bills that have been updated. Calls API for 20 views then uses offset query param to get further data as user scrolls down through ScrollView
// Shows BillRowView for each of the 20 returned recent bills
// Will likely change this to TabView at top level so user can swipe horizontal for other feed types
struct FeedView: View {
    @EnvironmentObject var recentBillVM: RecentBillViewModel
    @EnvironmentObject var specificBillVM: SpecificBillViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(recentBillVM.bills) { bill in
                        BillRowView(bill: bill).environmentObject(specificBillVM).onAppear {
                            recentBillVM.loadMoreContentIfNeeded(currentItem: bill)
                        }
                        Divider()
                    }
                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        let recentBills = ProPublicaAPI().fetchAPIBillsSearchData(query: "", pageNum: 0)!
        let recentBillsVM = RecentBillViewModel(recentResults: recentBills.results.first!)
        
        let specificBill = ProPublicaAPI().fetchAPIBillsSpecific(billSlug: recentBills.results.first!.bills.first!.bill_slug)!
        let specificBillVM = SpecificBillViewModel(specificResults: specificBill)
        
        FeedView().environmentObject(recentBillsVM).environmentObject(specificBillVM)
    }
}
