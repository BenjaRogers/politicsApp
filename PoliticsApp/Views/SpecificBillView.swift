//
//  SpecificBillView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/7/23.
//

import SwiftUI

struct SpecificBillView: View {
    @EnvironmentObject var specificBillVM: SpecificBillViewModel
    @State var bill: SpecificBill
    
    var body: some View {
        VStack {
            TabView {
                summaryTab
                latestActionsTab
                if specificBillVM.houseVoteCount != [] {
                    houseVoteDetailsTab
                }
                if specificBillVM.senateVoteCount != [] {
                    senateVoteDetailsTab
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        }
    }
}

struct SpecificBillView_Previews: PreviewProvider {
    static var previews: some View {
        let specificBill = ProPublicaAPI().fetchAPIBillsSpecific(billSlug: "hr4004")!
        SpecificBillView(bill: specificBill.results.first!).environmentObject(SpecificBillViewModel(specificResults: specificBill))
    }
}

extension SpecificBillView {
    // First tab when specific bill is selected
    // Contains Sponsor, bill slug, cosponsor(s) party affiliation, vote overview if applicable
    private var summaryTab: some View {
        ScrollView {
            VStack(alignment: .leading) {
                backButton
                HStack {
                    //Sponsor
                    Text("\(specificBillVM.bill!.sponsor_title) \(specificBillVM.bill!.sponsor) (\(specificBillVM.bill!.sponsor_party)-\(specificBillVM.bill!.sponsor_state)) (\(specificBillVM.bill!.getCosponsorString()))").foregroundColor(.gray)
                }
                
                Divider()
                
                // Bill type and # - functions as a name since the titles are sometimes paragraphs?
                Text(specificBillVM.bill!.bill_slug)
                    .font(.system(size: 22))
                    .fontWeight(.heavy)
                
                Spacer()
                
                HStack {
                    Text(specificBillVM.bill!.title).font(.headline)
                }
                if specificBillVM.bill!.summary != "" {
                    Text(specificBillVM.bill!.summary)
                        .font(.headline)
                }
            }.padding()
            Text("Vote Summary")
                .font(.system(size: 18))
                .fontWeight(.heavy)
            Text("Senate: ")
            if specificBillVM.senateVoteCount != []{
                senateVoteGraph
            } else {
                if bill.senate_passage == nil {
                    Text("This bill has not yet been voted on.")
                } else {
                    Text("Passed Senate \(bill.senate_passage!)")
                }
            }
            Text("House: ")
            if specificBillVM.houseVoteCount != [] {
                houseVoteGraph
                
            } else {
                if bill.house_passage == nil {
                    Text("This bill has not yet been voted on.")
                } else {
                    Text("Passed House \(bill.house_passage!)")
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
                ForEach(specificBillVM.bill!.actions) {action in
                    
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
            specificBillVM.showSpecificBillView = false
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
                        .frame(width: CGFloat(Double(specificBillVM.senateVoteCount[0]) / Double(specificBillVM.senateVoteCount[3])) * gp.size.width).overlay{Text("\(specificBillVM.senateVoteCount[0])")}
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: CGFloat(Double(specificBillVM.senateVoteCount[1]) / Double(specificBillVM.senateVoteCount[3])) * gp.size.width).overlay{Text("\(specificBillVM.senateVoteCount[1])")}
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: CGFloat(Double(specificBillVM.senateVoteCount[2]) / Double(specificBillVM.senateVoteCount[3])) * gp.size.width).overlay{Text("\(specificBillVM.senateVoteCount[2])")}
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
                        .frame(width: CGFloat(Double(specificBillVM.houseVoteCount[0]) / Double(specificBillVM.houseVoteCount[3])) * gp.size.width).overlay{Text("\(specificBillVM.houseVoteCount[0])")}
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: CGFloat(Double(specificBillVM.houseVoteCount[1]) / Double(specificBillVM.houseVoteCount[3])) * gp.size.width).overlay{Text("\(specificBillVM.houseVoteCount[1])")}
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: CGFloat(Double(specificBillVM.houseVoteCount[2]) / Double(specificBillVM.houseVoteCount[3])) * gp.size.width).overlay{Text("\(specificBillVM.houseVoteCount[2])")}
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
                Text("House Roll Call - \(specificBillVM.houseVoteResult)  \(specificBillVM.houseVoteDate)")
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                LazyVGrid(columns:columns, spacing: 4) {
                    if specificBillVM.houseVoteRollCall != [] {
                        ForEach(specificBillVM.houseVoteRollCall) {position in
                            
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
                Text("Senate Roll Call - \(specificBillVM.senateVoteResult)  \(specificBillVM.senateVoteDate)")
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                LazyVGrid(columns:columns, spacing: 4) {
                    if specificBillVM.senateVoteRollCall != [] {
                        ForEach(specificBillVM.senateVoteRollCall) {position in
                            
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
