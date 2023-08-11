//
//  VoteRollCallView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/11/23.
//

import SwiftUI

struct VoteRollCallView: View {
    @EnvironmentObject var specificBillVM: SpecificBillViewModel
    let columns = [GridItem(.fixed(200), alignment: .leading), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView {
            VStack {
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
        }
    }
}


struct VoteRollCallView_Previews: PreviewProvider {
    static var previews: some View {
        let specificBill = ProPublicaAPI().fetchAPIBillsSpecific(billSlug: "sjres9")!
        VoteRollCallView().environmentObject(SpecificBillViewModel(specificResults: specificBill))
    }
}
