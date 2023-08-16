//
//  PoliticsAppApp.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/2/23.
//

import SwiftUI

@main
struct PoliticsAppApp: App {
    @StateObject var recentBillVM = RecentBillViewModel(recentResults: ProPublicaAPI().fetchAPIBillsSearchData(query: "", pageNum: 0)!.results.first!)
    @StateObject var specificBillVM = SpecificBillViewModel(specificResults: ProPublicaAPI().fetchAPIBillsSpecific(congressSession: ProPublicaAPI().fetchAPIBillsSearchData(query: "", pageNum: 0)!.results.first!.bills.first!.congressSession!, billSlug: ProPublicaAPI().fetchAPIBillsSearchData(query: "", pageNum: 0)!.results.first!.bills.first!.bill_slug)!)
    
    
    var body: some Scene {
        WindowGroup {
            MainTabView().environmentObject(recentBillVM).environmentObject(specificBillVM)
        }
    }
}
