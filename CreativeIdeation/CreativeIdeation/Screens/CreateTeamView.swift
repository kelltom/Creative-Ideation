//
//  CreateTeamsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-24.
//

import SwiftUI
import Firebase

struct CreateTeamView: View {

    @State private var showBanner: Bool = false
    @Binding var showSheets: ActiveSheet?

    @State var teamName: String = ""
    @State var teamDescription: String = ""

    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            if teamViewModel.isShowingBanner {
                if teamViewModel.didOperationSucceed {
                    NotificationBanner(image: "checkmark.circle.fill", msg: teamViewModel.msg, color: .green)
                } else {
                    NotificationBanner(image: "exclamationmark.circle.fill", msg: teamViewModel.msg, color: .red)
                }
            }

            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }

            VStack {

                Text("Create Your Team")
                    .font(.system(size: 40))
                    .padding()

                VStack {

                    MenuTextField(title: "Team name", input: $teamName)

                    MenuTextField(title: "Team description (optional)", input: $teamDescription)

                    Button {
                        teamViewModel.createTeam(teamName: teamName, teamDescription: teamDescription)
                        teamName = ""
                        teamDescription = ""
                    } label: {
                        BigButton(title: "Create")
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
        }
        .onDisappear {
            teamViewModel.getTeams()
        }

    }

    private func delayAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                showBanner = false
            }
        }
    }
}

struct CreateTeamView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTeamView(showSheets: .constant(.team))
            .preferredColorScheme(.dark)
            .environmentObject(TeamViewModel())
    }
}
