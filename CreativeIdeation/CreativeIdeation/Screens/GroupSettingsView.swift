//
//  GroupSettingsView.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-08-27.
//

import SwiftUI

struct GroupSettingsView: View {

    @Binding var showGroupSettings: Bool
    @State var canOnlyAdminMakeSessions: Bool = true

    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel

    @State var selectedGroup: Group

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            // Back button required, as NavigationView not used to get to this page
            VStack {
                HStack {
                    Button {
                        showGroupSettings = false
                    } label: {
                        Text("< Back")
                    }
                    Spacer()
                }
                .padding(.leading, 30)
                Spacer()
            }

            GeometryReader { geometry in

                // Main content
                VStack {

                    Text("Group Settings")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()

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
                                } label: {
                                    // button design
                                    TextEditButton()
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

                                } label: {
                                    // button design
                                    TextEditButton()
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
                        // This code below is what we want, but it crashes the preview at the moment so it is commented out
//                        if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup!.groupId) {
//                            DeleteButton(text: "Delete Group")
//                        } else {
//                            DeleteButton(text: "Leave Group",
//                                         image: "rectangle.lefthalf.inset.fill.arrow.left",
//                                         backgroundColor: Color.gray)
//                        }
                    }
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
            }
            .banner(data: $groupViewModel.bannerData,
                    show: $groupViewModel.showBanner)
        }
        .onAppear {
            // Set groupViewModel.selectedGroup to the passed in Group object
            groupViewModel.selectedGroup = selectedGroup
        }
    }
}

struct GroupSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSettingsView(showGroupSettings: .constant(true), selectedGroup: Group())
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
