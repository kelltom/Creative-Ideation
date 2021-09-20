//
//  UpdateGroupMembersSheet.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-09-20.
//

import SwiftUI

enum Tab: Identifiable {
    case currentMembers, addMembers

    var id: Int {
        hashValue
    }
}

struct UpdateGroupMembersSheet: View {

    @State var isAdmin: Bool = true  // This should be loaded onAppear, otherwise I can just call the isAdmin function a lot
    @State var tab: Tab = .currentMembers  // This will depend on menu button clicked

    @Binding var showSheet: Sheets?

    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            if groupViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3)
            }

            // Exit button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showSheet = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.label))
                            .imageScale(.large)
                            .frame(width: 80, height: 80)
                    }
                }
                .padding()
                Spacer()
            }

            // Main page content
            GeometryReader { geometry in

                VStack {

                    Spacer()

                    // Main title
                    Text("Group Members")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    // Menu buttons
                    if isAdmin {

                        HStack {

                            // View current members button
                            Button {

                            } label: {
                                BigButton(title: "Current Members",
                                          geometry: geometry,
                                          widthScale: 0.2)
                            }

                            // Add members button
                            Button {

                            } label: {
                                BigButton(title: "Add Members",
                                          geometry: geometry,
                                          widthScale: 0.2)
                            }
                        }
                        .frame(width: geometry.size.width * 0.75)
                    }

                    // Multi-select view
                    // Probably only need the one?

                    // Remove Member button
                    if tab == .currentMembers && isAdmin {
                        Button {

                        } label: {
                            DeleteButton(text: "Remove Member(s)",
                                         image: "")
                        }
                    }

                    // Add Member button
                    if tab == .addMembers && isAdmin {
                        Button {

                        } label: {
                            DeleteButton(text: "Add Member(s)",
                                         image: "person.fill.badge.plus",
                                         backgroundColor: .green)  // TODO: We should either put a new custom button here, or refactor DeleteButton to be generic
                        }
                    }

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct UpdateGroupMembersSheet_Previews: PreviewProvider {
    static var previews: some View {
        UpdateGroupMembersSheet(showSheet: .constant(Sheets.members))
            .environmentObject(TeamViewModel())
            .environmentObject(GroupViewModel())
    }
}
