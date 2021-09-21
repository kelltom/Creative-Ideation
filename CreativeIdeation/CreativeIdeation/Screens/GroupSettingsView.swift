//
//  GroupSettingsView.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-08-27.
//

import SwiftUI

enum Sheets: Identifiable {
    case name, members

    var id: Int {
        hashValue
    }
}

struct GroupSettingsView: View {

    @Binding var showGroupSettings: Bool
    @State var showSheet: Sheets?
    @State var canOnlyAdminMakeSessions: Bool = true

    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            BackButton(text: "Home", binding: $showGroupSettings)

            GeometryReader { geometry in

                // Main content
                VStack {

                    Text("Group Settings")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                        .padding(.top, 20)  // Added to make heading position consistent with other settings screens that have custom back buttons

                    // Outer box
                    VStack {
                        // Inner box
                        VStack(alignment: .leading ) {

                            Text("Group Name")
                                .font(.title3)
                                .fontWeight(.bold)

                            HStack {
                                Text(groupViewModel.selectedGroup?.groupTitle ?? "Unknown")
                                    .font(.title3)

                                Spacer()

                                // Edit Group name
                                Button {
                                    showSheet = .name
                                } label: {
                                    // button design
                                    if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup!.groupId) {
                                        TextEditButton()
                                    } else {
                                        TextEditButton()
                                            .hidden()
                                    }
                                }
                            }

                            Text("Group Members")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                            HStack {
                                Text("Add or remove Group members")
                                    .font(.title3)
                                    .italic()

                                Spacer()

                                // Edit Team Members button
                                Button {
                                    showSheet = .members
                                } label: {
                                    // button design
                                    groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup!.groupId) ?
                                        TextEditButton() : TextEditButton(text: "View")
                                }
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.7, height: 260, alignment: .leading)
                        .background(Color("BackgroundColor"))
                        .cornerRadius(20)
                    }
                    .frame(width: geometry.size.width * 0.75, height: 300, alignment: .center)
                    .background(Color("brandPrimary"))
                    .cornerRadius(20)

                    Spacer()

                    // Delete/Leave button
                    Button {
                    } label: {
                        DeleteButton(text: "Delete Group")
                        /*
                        // Comment this out to make Preview work
                        if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup!.groupId) {
                            DeleteButton(text: "Delete Group")
                        } else {
                            DeleteButton(text: "Leave Group",
                                         image: "rectangle.lefthalf.inset.fill.arrow.left",
                                         backgroundColor: Color.gray)
                        }
                        */
                    }
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
            }
            .onAppear {
                teamViewModel.loadMembers()
            }
        }
        .sheet(item: $showSheet) { item in
            switch item {
            case .name:
                UpdateGroupNameSheet(showSheet: $showSheet)
                    .environmentObject(self.teamViewModel)
                    .environmentObject(self.groupViewModel)

            case .members:
                UpdateGroupMembersSheet(isAdmin: groupViewModel.isCurrentUserAdmin(
                                            groupId: groupViewModel.selectedGroup!.groupId),
                                            showSheet: $showSheet)
                    .environmentObject(teamViewModel)
                    .environmentObject(self.groupViewModel)
            }
        }
    }
}

struct GroupSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSettingsView(showGroupSettings: .constant(true))
            .environmentObject(TeamViewModel())
            .environmentObject(GroupViewModel())
    }
}

// The following struct and extension enable adding corner radiuses to specific corners of a view
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
