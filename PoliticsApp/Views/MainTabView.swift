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
    @EnvironmentObject var searchBillVM: SearchBillViewModel
    
    @EnvironmentObject var searchMembersVM: SearchMembersViewModel
    @EnvironmentObject var specificMemberVM: SpecificMemberViewModel
    
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
            SearchBillView()
                .onTapGesture {
                    self.selectedTabIndex = 1
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }.tag(1)
            NavigationView {
                SearchMemberView()
            }
            .onTapGesture {
                self.selectedTabIndex = 2
            }
            .tabItem {
                Image(systemName: "person.crop.rectangle.fill")
            }.tag(2)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let recentBillsVM = RecentBillViewModel(recentResults: ProPublicaAPI().fetchAPIBillsRecent(congressSession: 118, chamber: "both", type: "introduced", pageNum: 0)!.results.first!, congressSession: 118, chamber: "both", type: "introduced")
        
        let specificBillVM = SpecificBillViewModel(specificResults: ProPublicaAPI().fetchAPIBillsSpecific(congressSession: ProPublicaAPI().fetchAPIBillsRecent(congressSession: 118, chamber: "both", type: "introduced", pageNum: 0)!.results.first!.bills.first!.congressSession!, billSlug: ProPublicaAPI().fetchAPIBillsRecent(congressSession: 118, chamber: "both", type: "introduced", pageNum: 0)!.results.first!.bills.first!.bill_slug)!)
        
        let searchMembersVM = SearchMembersViewModel(congressSession: 118, chamber: "Senate")
        
        let specificMemberVM = SpecificMemberViewModel(memberID: "T000476")
        MainTabView().environmentObject(recentBillsVM).environmentObject(specificBillVM).environmentObject(searchMembersVM).environmentObject(specificMemberVM)
    }
}
