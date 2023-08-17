//
//  SearchBillView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/13/23.
//

import SwiftUI

struct SearchBillView: View {
    @EnvironmentObject var searchBillVM: SearchBillViewModel
    @EnvironmentObject var searchSpecificBillVM: SearchSpecificBillViewModel
    var body: some View {
        VStack {
            if searchBillVM.searchT == "id" {
                VStack {
                    backButton
                    specificBillBody
                }
            } else if searchBillVM.searchT == "keyword" {
                backButton
                ScrollView {
                    LazyVStack {
                        ForEach(searchBillVM.bills!) { bill in
                            BillRowView(bill: bill).onAppear {
                                searchBillVM.loadMoreContentIfNeeded(currentItem: bill)
                            }
                            Divider()
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if searchBillVM.bills!.count == 0 {
                            searchBillVM.toggleSearch()
                        }
                    }
                }
                .sheet(isPresented: $searchBillVM.showSearchMenu) {
                    SearchView()
                }
            }
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
    
    private var specificBillBody: some View {
        VStack {
            TabView {
                summaryTab
                latestActionsTab
                if searchSpecificBillVM.houseVoteCount != [] {
                    houseVoteDetailsTab
                }
                if searchSpecificBillVM.senateVoteCount != [] {
                    senateVoteDetailsTab
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        }
    }
    private var summaryTab: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    // Sponsor Info
                    Text("\(searchSpecificBillVM.bill!.sponsor_title) \(searchSpecificBillVM.bill!.sponsor) (\(searchSpecificBillVM.bill!.sponsor_party)-\(searchSpecificBillVM.bill!.sponsor_state)) (\(searchSpecificBillVM.bill!.getCosponsorString()))").foregroundColor(.gray)
                }
                
                Divider()
                
                // Bill type and # - functions as a name since the titles are sometimes paragraphs?
                Text(searchSpecificBillVM.bill!.bill_slug)
                    .font(.system(size: 22))
                    .fontWeight(.heavy)
                
                Spacer()
                
                HStack {
                    Text(searchSpecificBillVM.bill!.title).font(.headline)
                }
                if searchSpecificBillVM.bill!.summary != "" {
                    Text(searchSpecificBillVM.bill!.summary)
                        .font(.headline)
                }
            }.padding()
            Text("Vote Summary")
                .font(.system(size: 18))
                .fontWeight(.heavy)
            Text("Senate: ")
            if searchSpecificBillVM.senateVoteCount != []{
                senateVoteGraph
            } else {
                if searchSpecificBillVM.bill!.senate_passage == nil {
                    Text("This bill has not yet been voted on.")
                } else {
                    Text("Passed Senate \(searchSpecificBillVM.bill!.senate_passage!)")
                }
            }
            Text("House: ")
            if searchSpecificBillVM.houseVoteCount != [] {
                houseVoteGraph
                
            } else {
                if searchSpecificBillVM.bill!.house_passage == nil {
                    Text("This bill has not yet been voted on.")
                } else {
                    Text("Passed House \(searchSpecificBillVM.bill!.house_passage!)")
                }
            }
        }
    }
    // show progression of bill through committees votes etc. These can get pretty bulky so it is on its own tab in SpecificBillView
    private var latestActionsTab: some View {
        ScrollView {
            VStack(alignment: .leading) {
                backButton
                Text("Latest Actions")
                    .font(.system(size: 22))
                    .fontWeight(.heavy)
                Spacer()
                ForEach(searchSpecificBillVM.bill!.actions) {action in
                    
                    Text(action.datetime)
                    HStack {
                        Text("\(action.chamber) \(action.actionType)")
                    }
                    Text(action.description)
                    
                    
                    Image(systemName: "chevron.up")
                        .padding(1)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                }
            }.padding()
        }
    }
    // button to close sheet since having a scroll view nested in a tabview seems to remove the built in ability to swipe down to close a sheet
    // hopefully a place holder - at least needs work to look better in situ
    private var backButton: some View {
        Button {
            searchBillVM.searchT = "keyword"
            searchSpecificBillVM.resetViewModel()
            
        } label: {
            Image(systemName: "arrowshape.turn.up.backward")
        }
        .font(.headline)
        .padding(16)
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
    
    // Stacked horizontal bar chart for senate votes
    // Overlay doesnt work great for votes with only a few of a certain response i.e. only 2 people are 'not voting' since the section of the barchart is so thin the number gets cut off
    private var senateVoteGraph: some View {
        return VStack(alignment: .leading) {
            GeometryReader { gp in
                // chart is here
                HStack(spacing: 0) {
                    Rectangle().fill(Color.green)
                        .frame(width: CGFloat(Double(searchSpecificBillVM.senateVoteCount[0]) / Double(searchSpecificBillVM.senateVoteCount[3])) * gp.size.width).overlay{Text("\(searchSpecificBillVM.senateVoteCount[0])")}
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: CGFloat(Double(searchSpecificBillVM.senateVoteCount[1]) / Double(searchSpecificBillVM.senateVoteCount[3])) * gp.size.width).overlay{Text("\(searchSpecificBillVM.senateVoteCount[1])")}
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: CGFloat(Double(searchSpecificBillVM.senateVoteCount[2]) / Double(searchSpecificBillVM.senateVoteCount[3])) * gp.size.width).overlay{Text("\(searchSpecificBillVM.senateVoteCount[2])")}
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(height:45)
            .padding()
        }
    }
    
    // Stacked horizontal bar chart for house votes
    private var houseVoteGraph: some View {
        return VStack {
            GeometryReader { gp in
                HStack(spacing: 0) {
                    Rectangle().fill(Color.green)
                        .frame(width: CGFloat(Double(searchSpecificBillVM.houseVoteCount[0]) / Double(searchSpecificBillVM.houseVoteCount[3])) * gp.size.width).overlay{Text("\(searchSpecificBillVM.houseVoteCount[0])")}
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: CGFloat(Double(searchSpecificBillVM.houseVoteCount[1]) / Double(searchSpecificBillVM.houseVoteCount[3])) * gp.size.width).overlay{Text("\(searchSpecificBillVM.houseVoteCount[1])")}
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: CGFloat(Double(searchSpecificBillVM.houseVoteCount[2]) / Double(searchSpecificBillVM.houseVoteCount[3])) * gp.size.width).overlay{Text("\(searchSpecificBillVM.houseVoteCount[2])")}
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(height:45)
            .padding()
        }
    }
    private var houseVoteDetailsTab: some View {
        let columns = [GridItem(.fixed(200), alignment: .leading), GridItem(.flexible()), GridItem(.flexible())]
        return ScrollView {
            VStack(alignment: .leading) {
                backButton
                Text("House Roll Call - \(searchSpecificBillVM.houseVoteResult)  \(searchSpecificBillVM.houseVoteDate)")
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                LazyVGrid(columns:columns, spacing: 4) {
                    if searchSpecificBillVM.houseVoteRollCall != [] {
                        ForEach(searchSpecificBillVM.houseVoteRollCall) {position in
                            
                            Text(position.name!)
                            Text(position.party!)
                            Text(position.vote_position!)
                        }
                    }
                }
            }
        }.padding()
    }
    private var senateVoteDetailsTab: some View {
        let columns = [GridItem(.fixed(200), alignment: .leading), GridItem(.flexible()), GridItem(.flexible())]
        return ScrollView {
            VStack(alignment: .leading) {
                backButton
                Text("Senate Roll Call - \(searchSpecificBillVM.senateVoteResult)  \(searchSpecificBillVM.senateVoteDate)")
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                LazyVGrid(columns:columns, spacing: 4) {
                    if searchSpecificBillVM.senateVoteRollCall != [] {
                        ForEach(searchSpecificBillVM.senateVoteRollCall) {position in
                            
                            Text(position.name!)
                            Text(position.party!)
                            Text(position.vote_position!)
                            
                        }
                    }
                }
            }
        }.padding()
    }
}
