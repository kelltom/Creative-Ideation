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
                        .font(.system(size: 40))
                        .padding()

                    VStack {

                        EditTextField(title: "Team name", input: $teamName, geometry: geometry, widthScale: 0.75)

                        EditTextField(title: "Team description (optional)", input: $teamDescription, geometry: geometry, widthScale: 0.75)

                        Button {
                            if pFilter.containsProfanity(text: teamName).profanities.count == 0 &&
                                pFilter.containsProfanity(text: teamDescription).profanities.count == 0 {
                                teamViewModel.createTeam(teamName: teamName, teamDescription: teamDescription)
                                teamName = ""
                                teamDescription = ""
                            } else {
                                // Create banner notification telling the user that they cannot use profanity in their team name or description
                            }
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
