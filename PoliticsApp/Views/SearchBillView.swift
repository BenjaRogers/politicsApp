//
//  SearchBillView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/13/23.
//

import SwiftUI

struct SearchBillView: View {
    @EnvironmentObject var searchBillVM: SearchBillViewModel
    @EnvironmentObject var specificBillVM: SearchSpecificBillViewModel
    var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(searchBillVM.bills!) { bill in
                    BillRowView(bill: bill).environmentObject(specificBillVM).onAppear {
                        searchBillVM.loadMoreContentIfNeeded(currentItem: bill)
                    }
                    Divider()
                }
            }
        }
        .onAppear {
            if searchBillVM.bills!.count == 0 {
                searchBillVM.toggleSearch()
            }
        }
        .sheet(isPresented: $searchBillVM.showSearchMenu) {
            SearchView()
        }
    }
}

struct SearchBillView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBillView().environmentObject(SearchBillViewModel()).environmentObject(SearchSpecificBillViewModel())
    }
}

extension SearchBillView {
    var searchButton: some View {
        Button{
            searchBillVM.toggleSearch()
        } label: {
            Text("Search")
        }
    }
}
