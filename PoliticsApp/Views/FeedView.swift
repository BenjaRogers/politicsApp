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
    
    @State var selectedTabIndex: Int = 0
    var body: some View {
        VStack {
            tabHeader
            ScrollView {
                LazyVStack {
                    ForEach(recentBillVM.bills) { bill in
                        BillRowView(bill: bill).environmentObject(specificBillVM)
                            .onAppear {
                                recentBillVM.loadMoreContentIfNeeded(currentItem: bill)
                                print(bill.bill_id)
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
        let recentBills = ProPublicaAPI().fetchAPIBillsRecent(congressSession: 118, chamber: "both", type: "introduced", pageNum: 0)!
        let recentBillsVM = RecentBillViewModel(recentResults: recentBills.results.first!, congressSession:118, chamber: "both", type:"introduced")
        
        let specificBill = ProPublicaAPI().fetchAPIBillsSpecific(congressSession: recentBills.results.first!.bills.first!.congressSession!, billSlug: recentBills.results.first!.bills.first!.bill_slug)!
        let specificBillVM = SpecificBillViewModel(specificResults: specificBill)
        
        FeedView().environmentObject(recentBillsVM).environmentObject(specificBillVM)
    }
}

extension FeedView {
    var tabHeader: some View {
        
        Picker("", selection: self.$selectedTabIndex) {
            Text("Introduced").tag(0)
            Text("Updated").tag(1)
            Text("Active").tag(2)
            Text("Passed").tag(3)
            Text("Enacted").tag(4)
            Text("Vetoed").tag(5)
        }.pickerStyle(.segmented)
            .onChange(of: selectedTabIndex) { newValue in
                switch(selectedTabIndex) {
                case 0:
                    recentBillVM.updateViewModelSearchParams(congressSession: 118, chamber: "both", type: "introduced")
                case 1:
                    recentBillVM.updateViewModelSearchParams(congressSession: 118, chamber: "both", type: "updated")
                case 2:
                    recentBillVM.updateViewModelSearchParams(congressSession: 118, chamber: "both", type: "active")
                case 3:
                    recentBillVM.updateViewModelSearchParams(congressSession: 118, chamber: "both", type: "passed")
                case 4:
                    recentBillVM.updateViewModelSearchParams(congressSession: 118, chamber: "both", type: "enacted")
                case 5:
                    recentBillVM.updateViewModelSearchParams(congressSession: 118, chamber: "both", type: "vetoed")
                default:
                    recentBillVM.updateViewModelSearchParams(congressSession: 118, chamber: "both", type: "introduced")
                }
                recentBillVM.updateViewModelBills()
            }
    }
}
