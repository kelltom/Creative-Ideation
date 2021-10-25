//
//  CreateGroupView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-25.
//

import SwiftUI
import Profanity_Filter

struct CreateGroupSheet: View {

    @State var groupTitle: String = ""
    @State var groupDescription: String = ""

    @State private var members: [Member] = []
    @State private var multiSelection = Set<String>()
    @State private var editMode: EditMode = .active

    @State private var widthScale: CGFloat = 0.75  // percentage width of screen UI should use

    @Binding var showSheets: ActiveSheet?

    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel

    var pFilter = ProfanityFilter()

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }

            GeometryReader { geometry in

                VStack {

                    Spacer()
                        .frame(height: geometry.size.height * 0.1)

                    Text("Create Your Group")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    VStack {

                        // Enter Group Name title
                        HStack {
                            Text("Enter Group Name")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        .frame(width: geometry.size.width * widthScale)

                        EditTextField(title: "Group Name", input: $groupTitle, geometry: geometry, widthScale: widthScale)

                        // Select Group Members title
                        HStack {
                            Text("Add Following Team Members")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .frame(width: geometry.size.width * widthScale)

                        List(teamViewModel.getTeamMembers(includeCurrentUser: false), selection: $multiSelection) {
                            Text($0.name)
                                .font(.title2)
                        }
                        .cornerRadius(15)
                        .environment(\.editMode, self.$editMode)
                        .frame(width: geometry.size.width * widthScale)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke())

                        Button {
                            groupViewModel.createGroup(teamId: teamViewModel.selectedTeam?.teamId,
                                                       groupTitle: groupTitle,
                                                       memberIds: Array(multiSelection))
                            groupTitle = ""
                        } label: {
                            BigButton(title: "Create", geometry: geometry, widthScale: widthScale)
                        }
                    }
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            }
            .banner(data: $groupViewModel.bannerData,
                    show: $groupViewModel.showBanner)
        }
        .onChange(of: groupViewModel.wasCreateSuccess, perform: { _ in
            if groupViewModel.wasCreateSuccess {
                groupViewModel.selectedGroup = groupViewModel.groups.last
                multiSelection = Set<String>()
            }
        })
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupSheet(showSheets: .constant(.group))
            .environmentObject(GroupViewModel())
            .environmentObject(TeamViewModel())
    }
}
