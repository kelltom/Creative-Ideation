//
//  TeamSettingsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

struct TeamSettingsView: View {

    @State private var profanityFilter = true

    var teamName: String = "My Team"
    var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"

    /// Indicates whether current Team is private, which disables/enables certain fields
    var isPrivate: Bool

    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            VStack {

                Text("Team Settings")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                VStack {

                    Button {
                        // do stuff
                    } label: {
                        PreferencePic().padding()
                    }

                    VStack(alignment: .leading ) {

                        Text("Team Name")
                            .font(.system(size: 25))
                            .fontWeight(.bold)

                        HStack {

                            Text(teamName)
                                .font(.system(size: 18))

                            Spacer()

                            Button {
                                // button functionality
                            } label: {
                                // button design
                                TextEditButton()
                            }
                        }

                        Text("Description")
                            .font(.system(size: 25))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                        HStack {

                            Text(description)
                                .font(.system(size: 18))

                            Spacer()

                            Button {
                                // button functionality
                            } label: {
                                // button design
                                TextEditButton()
                            }

                        }
                    }
                    .padding()
                    .frame(minWidth: 100, maxWidth: 650, maxHeight: 340, alignment: .leading)
                    .background(Color("BackgroundColor"))
                    .cornerRadius(10)

                }
                .frame(maxWidth: 700, maxHeight: 500, alignment: .center)
                .background(Color("brandPrimary"))
                .cornerRadius(20)

                VStack(alignment: .leading) {

                    Text("Profanity Control")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(.top)
                        .padding()

                    HStack {
                        Toggle("Filter Specfic Words", isOn: $profanityFilter)
                            .padding()
                    }

                    HStack {

                        Text("Blocked Words List")
                            .padding()

                        Spacer()

                        Button {
                            // button functionality
                        } label: {
                            // button design
                            TextEditButton()
                        }
                    }

                }
                .frame(maxWidth: 650, maxHeight: 230)

                Divider()
                    .frame(maxWidth: 650)
                    .background(Color("FadedColor"))

                Spacer()

                Button {
                    teamViewModel.deleteSelectedTeam(teamId: teamViewModel.selectedTeam?.teamId)
                } label: {
                    DeleteButton(backgroundColor: isPrivate ? .gray : .red)
                }
                .disabled(isPrivate)
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct TeamSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSettingsView(teamName: "Team Name", description: "Some description here", isPrivate: false)
            .preferredColorScheme(.dark)
            .environmentObject(TeamViewModel())
    }
}
