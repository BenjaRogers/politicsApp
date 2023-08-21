//
//  SpecificMemberView.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/17/23.
//

import SwiftUI

struct SpecificMemberView: View {
    @EnvironmentObject var specificMemberVM: SpecificMemberViewModel
    @EnvironmentObject var specificBillVM: SpecificBillViewModel
    
    @State private var selectedFilter: MemberFilterViewModel = .sponsor
    @State var searchMemberID: String
    
    var body: some View {
        VStack {
            header
            
            followButton
            
            memberTitle
            
            memberInfo
            
            memberFilterBar
            
            ScrollView {
                LazyVStack {
                    ForEach(specificMemberVM.memberRecentBills) { bill in
                        SponsoredBillRowView(bill: bill)
                            .onAppear {
                                specificMemberVM.loadMoreContentIfNeeded(currentItem: bill)
                                
                            }
                    }
                }
            }
        }.onAppear {
            specificMemberVM.updateSpecificMember(memberID: searchMemberID)
        }
    }
}

//struct SpecificMemberView_Previews: PreviewProvider {
//    static var previews: some View {
//        let specificMemberVM = SpecificMemberViewModel(memberID: "M001183")
//        
//        SpecificMemberView().environmentObject(specificMemberVM)
//    }
//}

extension SpecificMemberView {
    
    var header: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.systemIndigo)
                .ignoresSafeArea()
            AsyncImage(url: URL(string: ("https://theunitedstates.io/images/congress/225x275/\(specificMemberVM.member.id).jpg"))){image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:72, height: 72)
                    .clipShape(Circle())
            }
            .offset(x: 16, y: 24)
        }
        .frame(height: 96)
    }
    
    var followButton: some View {
        HStack (spacing: 10) {
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "hand.thumbsup")
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
            }
            
            Button {
                
            } label: {
                Image(systemName: "hand.thumbsdown")
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
            }
            
            Button {
                
            } label: {
                Text("Follow")
                    .font(.subheadline).bold()
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
            }
        }
        .padding()
        .frame(height: 48)
    }
    
    var memberTitle: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(specificMemberVM.member.roles.first!.short_title) \(specificMemberVM.member.full_name)")
                    .font(.title2).bold()
                Spacer()
            }
            Text("\(specificMemberVM.member.current_party!) - \(specificMemberVM.member.roles.first!.state)")
                .font(.title3).bold()
                .foregroundColor(.gray)
        }.padding()
    }
    
    var memberInfo: some View {
        VStack (alignment: .leading, spacing: 18){
            HStack(spacing: 6) {
                Image(systemName: "pin.square.fill").foregroundColor(.gray)
                Text("\(specificMemberVM.member.roles.first!.office ?? "")")
                    .foregroundColor(.gray)
                    .bold()
                
                Spacer()
                
                Image(systemName: "phone.fill").foregroundColor(.gray)
                Text("\(specificMemberVM.member.roles.first!.phone ?? "")")
                    .foregroundColor(.gray)
                    .bold()
            }
            HStack {
                HStack {
                    Text("100")
                        .bold()
                    Text("Likes")
                        .foregroundColor(.gray)
                        .bold()
                }
                HStack {
                    Text("150")
                        .bold()
                    Text("Followers")
                        .foregroundColor(.gray)
                        .bold()
                }
            }
        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
    }
    
    var memberFilterBar: some View {
        HStack {
            ForEach(MemberFilterViewModel.allCases, id: \.rawValue) {filter in
                VStack {
                    Text(filter.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == filter ? .semibold : .regular)
                        .foregroundColor(selectedFilter == filter ? .black : .gray)
                    
                    if selectedFilter == filter {
                        Capsule()
                            .foregroundColor(Color(.systemIndigo))
                            .frame(height:3)
                    } else {
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height:3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedFilter = filter
                    }
                }
            }
        }
    }
}
