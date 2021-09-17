//
//  CreateTeamsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-24.
//

import SwiftUI
import Firebase
import Profanity_Filter

struct CreateTeamSheet: View {

    @State private var showBanner: Bool = false
    @Binding var showSheets: ActiveSheet?

    @State var teamName: String = ""
    @State var teamDescription: String = ""
    @State private var widthScale: CGFloat = 0.75  // percentage width of screen UI should use

    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupviewModel: GroupViewModel

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

                    Text("Create Your Team")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    // Enter Team Name title
                    HStack {
                        Text("Enter Team Name")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                    .frame(width: geometry.size.width * widthScale)

                    VStack {

                        EditTextField(title: "Team Name", input: $teamName, geometry: geometry, widthScale: 0.75)

                        // Enter Team Name title
                        HStack {
                            Text("Enter Team Name")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        .frame(width: geometry.size.width * widthScale)

                        EditTextField(title: "Team Description (Optional)", input: $teamDescription, geometry: geometry, widthScale: 0.75)

                        Button {
                            teamViewModel.createTeam(teamName: teamName, teamDescription: teamDescription)
                            teamName = ""
                            teamDescription = ""
                        } label: {
                            BigButton(title: "Create", geometry: geometry, widthScale: 0.75)
                                .padding(.top, 5)
                        }

                        Text("or")
                            .hidden()

                        // Create Acc Button
                        NavigationLink(destination: EmptyView()) {
                            Text("Reactivate pre-existing team.")
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        }
                        .padding(.top)
                        .hidden()

                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .banner(data: $teamViewModel.bannerData, show: $teamViewModel.showBanner)
        }
        .onChange(of: teamViewModel.didCreateSuccess) { didSucceed in
            if didSucceed {
                // Create "Everyone" default Group for this Team
                groupviewModel.createGroup(teamId: teamViewModel.newTeamId, groupTitle: "Public", suppressBanner: true, isPublic: true)

                teamViewModel.didCreateSuccess = false
            }
        }
    }
}

struct CreateTeamView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTeamSheet(showSheets: .constant(.team))
            .preferredColorScheme(.dark)
            .environmentObject(TeamViewModel())
            .environmentObject(GroupViewModel())
    }
}
