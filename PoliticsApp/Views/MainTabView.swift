//
//  MainTabView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/11/23.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var recentBillVM: RecentBillViewModel
    @EnvironmentObject var specificBillVM: SpecificBillViewModel
    
    @State private var selectedTabIndex = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            FeedView()
                .onTapGesture {
                    self.selectedTabIndex = 0
                }
                .tabItem {
                    Image(systemName: "house")
                }.tag(0)
            SearchBillView().environmentObject(SearchBillViewModel()).environmentObject(SearchSpecificBillViewModel())
                .onTapGesture {
                    self.selectedTabIndex = 1
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }.tag(1)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let recentBills = ProPublicaAPI().fetchAPIBillsSearchData(query: "", pageNum: 0)!
        let recentBillsVM = RecentBillViewModel(recentResults: recentBills.results.first!)
        
        let specificBill = ProPublicaAPI().fetchAPIBillsSpecific(billSlug: recentBills.results.first!.bills.first!.bill_slug)!
        let specificBillVM = SpecificBillViewModel(specificResults: specificBill)
        
        MainTabView().environmentObject(recentBillsVM).environmentObject(specificBillVM)
    }
}
