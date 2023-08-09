//
//  BillRowView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/5/23.
//

import SwiftUI

struct BillRowView: View {
    @EnvironmentObject var specificBillVM: SpecificBillViewModel
    @State var bill: RecentBill
    @State var showSpecificBill: Bool = false
    
    var body: some View {
        VStack {
                BillRowSummary
                BillRowButtons
        }
    }
}

struct BillRowView_Previews: PreviewProvider {
    static var previews: some View {
        let billJSON = ProPublicaAPI().fetchAPIBillsSearchData(query: "", pageNum: 0)
        let bill = billJSON!.results.first!.bills.first
        let billSlug = bill!.bill_slug
        let billVM = SpecificBillViewModel(specificResults: ProPublicaAPI().fetchAPIBillsSpecific(billSlug: billSlug)!)
        BillRowView(bill:bill!).environmentObject(billVM)
    }
}

extension BillRowView {
    private var BillRowSummary: some View {
        // Whole Billrow is clickable above buttons. Clicking a bill opens a more detailed bill TabView SpecificBillView.
        Button {
            specificBillVM.nextSpecificBill(specificResults: ProPublicaAPI().fetchAPIBillsSpecific(billSlug: bill.bill_slug)!)
            specificBillVM.showSpecificBillView = true
        } label: {
            // Placeholder for actual image of bill sponsor
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .frame(width: 56, height: 56)
                    .foregroundColor(Color(.systemBlue))
                
                // Header with sponsor name and bill slug
                VStack(alignment: .leading, spacing: 4) {
                    HStack() {
                        Text(bill.bill_slug)
                            .font(.subheadline).bold()
                        Text(bill.sponsor_name)
                            .foregroundColor(.gray)
                            .font(.caption).bold()
                        Spacer()
                        Text("\(Calendar.current.dateDiffCalc(datePosted: bill.latest_major_action_date))D")
                            .font(.subheadline)
                    }
                    // Bill title. These tend to be really long and kind of serve as a summary? SpecificBill's summary property dont seem to get updated until the bill is pretty far along in the process. Always has a title though
                    HStack {
                        Text(bill.title)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                    }
                }
            }.padding()
        }.sheet(isPresented: $specificBillVM.showSpecificBillView, onDismiss: nil) {
            SpecificBillView(bill: specificBillVM.bill!)
        }
    }
    
    // Need to implement these button actions. Idea is to send this to hosted backend that stores user engagement.
    private var BillRowButtons: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName:"bubble.left")
                    .font(.subheadline)
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName:"hand.thumbsup")
                    .font(.subheadline)
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName:"hand.thumbsdown")
                    .font(.subheadline)
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName:"bookmark")
                    .font(.subheadline)
            }
        }.padding()
    }
}
