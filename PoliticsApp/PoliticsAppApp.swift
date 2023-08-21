//
//  PoliticsAppApp.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/2/23.
//

import SwiftUI

@main
struct PoliticsAppApp: App {
    @StateObject var recentBillVM = RecentBillViewModel(recentResults: ProPublicaAPI().fetchAPIBillsRecent(congressSession: 118, chamber: "both", type: "introduced", pageNum: 0)!.results.first!, congressSession: 118, chamber: "both", type: "introduced")
    @StateObject var specificBillVM = SpecificBillViewModel(specificResults: ProPublicaAPI().fetchAPIBillsSpecific(congressSession: ProPublicaAPI().fetchAPIBillsRecent(congressSession: 118, chamber: "both", type: "introduced", pageNum: 0)!.results.first!.bills.first!.congressSession!, billSlug: ProPublicaAPI().fetchAPIBillsRecent(congressSession: 118, chamber: "both", type: "introduced", pageNum: 0)!.results.first!.bills.first!.bill_slug)!)
    @StateObject var searchBillVM = SearchBillViewModel()
    
    @StateObject var searchMemberVM = SearchMembersViewModel(congressSession: 118, chamber: "Senate")
    @StateObject var specificMemberVM = SpecificMemberViewModel(memberID: "T000476")
    
    var body: some Scene {
        WindowGroup {
            MainTabView().environmentObject(recentBillVM).environmentObject(specificBillVM).environmentObject(searchMemberVM).environmentObject(specificMemberVM).environmentObject(searchBillVM)
        }
    }
}
