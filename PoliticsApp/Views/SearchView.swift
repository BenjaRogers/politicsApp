//
//  SearchView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/11/23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchBillVM: SearchBillViewModel
    @EnvironmentObject var searchSpecificBillVM: SearchSpecificBillViewModel
    
    @State var searchType: String = "keyword"
    @State var congressSession: Int = 118
    @State var searchTerms: String = ""
    @State var navigateSearch: Bool = false
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    HStack {
                        Picker(selection: $searchType, label: Text("Type")) {
                            Text("ID").tag("billID")
                            Text("Keyword").tag("keyword")
                        }.pickerStyle(.segmented)
                    }
                    Picker("Session", selection: $congressSession){
                        Text("118").tag(118)
                        Text("117").tag(117)
                        Text("116").tag(116)
                    }
                    
                    if searchType == "billID" {
                        TextField("Ex. hr4004", text: $searchTerms)
                    }
                    if searchType == "keyword" {
                        TextField("Ex. Health", text: $searchTerms)
                    }
                    Button {
                        if searchType == "keyword" {
                            searchBillVM.updateKeywordSearchResults(query:searchTerms)
                            if searchBillVM.bills!.count > 0 {
                                searchSpecificBillVM.updateSearchResults(congressSession: searchBillVM.bills!.first!.congressSession!, billSlug:searchBillVM.bills!.first!.bill_slug)
                            }
                            searchBillVM.searchT = "keyword"
                        } else if searchType == "billID" {
                            searchSpecificBillVM.updateSearchResults(congressSession: congressSession, billSlug: searchTerms)
                            searchBillVM.searchT = "id"
                        }
                        searchBillVM.toggleSearch()
                        
                    } label: {
                        Text("Search")
                    }
                }
                
            }
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let searchBillVM = SearchBillViewModel()
        let searchSpecificBillVM = SearchSpecificBillViewModel()
        SearchView().environmentObject(searchBillVM).environmentObject(searchSpecificBillVM)
    }
}

extension SearchView {
    var searchResults: some View {
        ScrollView {
            if searchBillVM.bills!.count > 0 {
                ForEach(searchBillVM.bills!) { bill in
                    BillRowView(bill: bill).environmentObject(searchBillVM).onAppear {
                        searchBillVM.loadMoreContentIfNeeded(currentItem: bill)
                    }
                    Divider()
                }
            }
            
        }
    }
}
