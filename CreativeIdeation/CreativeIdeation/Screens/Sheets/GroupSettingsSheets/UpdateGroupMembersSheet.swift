//
//  UpdateGroupMembersSheet.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-09-20.
//

import SwiftUI

enum Tab: Identifiable {
    case currentMembers, addMembers, none

    var id: Int {
        hashValue
    }
}

struct UpdateGroupMembersSheet: View {

    @State var isAdmin: Bool
    @State var tab: Tab = .none

    @State private var multiSelection = Set<String>()
    @State private var editMode: EditMode = .active  // Determined by admin status

    @Binding var showSheet: Sheets?

    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

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
                        .frame(height: geometry.size.height * 0.1)

                    // Main title
                    Text("Group Members")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    // Menu buttons
                    if isAdmin {

                        HStack {

                            // View current members button
                            Button {
                                tab = .currentMembers
                            } label: {
                                BigButton(title: "Current Members",
                                          geometry: geometry,
                                          widthScale: 0.2)
                            }

                            // Add members button
                            Button {
                                tab = .addMembers
                            } label: {
                                BigButton(title: "Add Members",
                                          geometry: geometry,
                                          widthScale: 0.2)
                            }
                        }
                        .frame(width: geometry.size.width * 0.75)
                    }

                    // Multi-select view
                    List((tab == .currentMembers) ? groupViewModel.groupMembers : groupViewModel.nonMembers, selection: $multiSelection) {
                        Text($0.name)
                            .font(.title2)
                    }
                    .cornerRadius(15)
                    .environment(\.editMode, self.$editMode)
                    .frame(width: geometry.size.width * 0.75)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke())

                    // Remove Member button
                    if tab == .currentMembers && isAdmin {
                        Button {
                            groupViewModel.removeMembers(memberIds: multiSelection)
                            multiSelection.removeAll()
                        } label: {
                            DeleteButton(text: "Remove Member(s)",
                                         image: "")
                        }
                    }

                    // Add Member button
                    if tab == .addMembers && isAdmin {
                        Button {
                            groupViewModel.addMembers(memberIds: multiSelection)
                            multiSelection.removeAll()
                        } label: {
                            DeleteButton(text: "Add Member(s)",
                                         image: "person.fill.badge.plus",
                                         backgroundColor: .green)  // TODO: We should either put a new custom button here, or refactor DeleteButton to be generic
                        }
                    }

                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .banner(data: $groupViewModel.bannerData,
                    show: $groupViewModel.showBanner)

            if groupViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3)
            }
        }
        .onAppear {

            // Determine admin status, set edit mode accordingly
            if !isAdmin {
                editMode = .inactive
            }

            tab = .currentMembers
        }
        .onChange(of: tab, perform: { _ in
            // Remove multi-selection and re-load list of members
            multiSelection.removeAll()
            groupViewModel.splitMembers(teamMembers: teamViewModel.teamMembers)
        })
    }
}

struct UpdateGroupMembersSheet_Previews: PreviewProvider {
    static var previews: some View {
        UpdateGroupMembersSheet(isAdmin: true, showSheet: .constant(Sheets.members))
            .environmentObject(TeamViewModel())
            .environmentObject(GroupViewModel())
    }
}
