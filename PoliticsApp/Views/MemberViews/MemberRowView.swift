//
//  MemberRowView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/17/23.
//

import SwiftUI

struct MemberRowView: View {
    @EnvironmentObject var specificMemberVM: SpecificMemberViewModel
    
    @State var member: Member
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack (alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: ("https://theunitedstates.io/images/congress/225x275/\(member.id).jpg"))){image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 54, height: 54)
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width:48, height: 48)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading){
                    Text("\(member.short_title) \(member.first_name) \(member.last_name)").fontWeight(.bold)
                    Text("\(member.party) - \(member.state)")
                }
            }
        }
    }
}
    
struct MemberRowView_Previews: PreviewProvider {
    static var previews: some View {
        let searchMemberVM = SearchMembersViewModel(congressSession: 118, chamber: "senate")
        let specificMemberVM = SpecificMemberViewModel(memberID: "M001183")
        MemberRowView(member: searchMemberVM.members.first!).environmentObject(specificMemberVM)
    }
}
    
