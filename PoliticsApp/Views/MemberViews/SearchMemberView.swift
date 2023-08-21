//
//  SearchMemberView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/17/23.
//

import SwiftUI

struct SearchMemberView: View {
    @EnvironmentObject var searchMemberVM: SearchMembersViewModel
    @EnvironmentObject var specificMemberVM: SpecificMemberViewModel
    
    @State private var members: [Member] = []
    @State private var searchText = ""
    
    var body: some View {
        
        List {
            ForEach(members) { member in
                NavigationLink(destination: SpecificMemberView(searchMemberID: member.id)) {
                    MemberRowView(member: member)
                }
            }
        }.searchable(text: $searchText)
        
            .onChange(of: searchText) { searchText in
                
                if !searchText.isEmpty {
                    members = searchMemberVM.members.filter { $0.first_last_name.contains(searchText) }
                } else {
                    members = searchMemberVM.members
                }
            }
            .onAppear() {
                members = searchMemberVM.members
            }
    }
}

struct SearchMemberView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchMemberView().environmentObject(SearchMembersViewModel(congressSession: 118, chamber: "senate")).environmentObject(SpecificMemberViewModel(memberID: "T000476"))
        }
    }
}
