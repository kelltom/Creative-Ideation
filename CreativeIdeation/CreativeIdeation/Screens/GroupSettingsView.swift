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
                VStack {
                    // Page title
                    Text("Group Settings")
                        .font(.largeTitle)
                        .bold()
                        .frame(height: geometry.size.height * 0.1, alignment: .center)

                    // Main content
                    VStack {

                        // Edit Group Name
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Group Name")
                                    .font(.title2)
                                    .fontWeight(.bold)

                                Text("Unknown")
                                    .font(.title3)
                            }

                            Spacer()

                            Button {
                                // showSheet = .name
                            } label: {
                                TextEditButton(hasPadding: false)
                            }
                        }
                        .padding(.bottom, 20)

                        // Only Admin can create Sessions?
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Only Admin can create Sessions?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }

                            Spacer()

                            Toggle("", isOn: $canOnlyAdminMakeSessions)
                                .padding(.trailing)
                        }
                        .padding(.bottom, 20)

                        // Edit Members
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    // Edit Group Members
                                    Text("Group Members")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }

                                Spacer()

                                Button {
                                    // showSheet = .name
                                } label: {
                                    TextEditButton(text: "Add", hasPadding: false)
                                }
                            }

                            // Display list of members
                            Text("Hi")
                                .frame(width: geometry.size.width * 0.75,
                                       height: geometry.size.height * 0.8 * 0.3)
                                .background(Color.gray)
                                .padding(.top)
                        }

                        Spacer()
                    }
                    .frame(width: geometry.size.width * 0.75,
                           height: geometry.size.height * 0.8,
                           alignment: .center)

                    // Delete/Leave button
                    Text("Leave/Delete button here")
                        .frame(height: geometry.size.height * 0.1, alignment: .center)
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
