//
//  TeamSettingsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

enum EditSheet: Identifiable {
    case name, description

    var id: Int {
        hashValue
    }
}

struct TeamSettingsView: View {
    /// Indicates whether current Team is private, which disables/enables certain fields
    var isPrivate: Bool
    var teamName: String = "My Team"
    var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"

    @State private var profanityFilter = true
    @State var showSheet: EditSheet?
    
    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            GeometryReader { geometry in

                VStack {

                    Text("Team Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    VStack {

                        Button {
                            // do stuff
                        } label: {
                            PreferencePic().padding()
                        }

                        VStack(alignment: .leading ) {

                            Text("Team Name")
                                .font(.title3)
                                .fontWeight(.bold)

                            HStack {

                                Text(teamViewModel.selectedTeam?.teamName ?? "Unknown")
                                    .font(.title3)

                                Spacer()

                                Button {
                                    // button functionality
                                    showSheet = .name
                                } label: {
                                    // button design
                                    TextEditButton()
                                }
                            }

                            Text("Description")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                            HStack {

                                Text(teamViewModel.selectedTeam?.teamDescription ?? "No Description")
                                    .font(.title3)

                                Spacer()

                                Button {
                                    // button functionality
                                    showSheet = .description
                                } label: {
                                    // button design
                                    TextEditButton()
                                }

                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.7, height: 300, alignment: .leading)
                        .background(Color("BackgroundColor"))
                        .cornerRadius(20)
                    }
                    .frame(width: geometry.size.width * 0.75, height: 450, alignment: .center)
                    .padding(.bottom)
                    .background(Color("brandPrimary"))
                    .cornerRadius(20)

                    VStack(alignment: .leading) {

                        Text("Profanity Control")
                            .font(.title3)
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
                    .frame(width: geometry.size.width * 0.70, height: 230)

                    Divider()
                        .frame(width: geometry.size.width * 0.70)
                        .background(Color("FadedColor"))

                    Spacer()

                    Button {
                        teamViewModel.deleteSelectedTeam(teamId: teamViewModel.selectedTeam?.teamId)
                    } label: {
                        DeleteButton(backgroundColor: isPrivate ? .gray : .red)
                    }
                    .disabled(isPrivate)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .sheet(item: $showSheet) { item in
                    switch item {

                    case .name:
                        UpdateTeamNameSheet(showSheet: $showSheet)
                            .environmentObject(self.teamViewModel)

                    case .description:
                        UpdateTeamDescriptionSheet(showSheet: $showSheet)
                            .environmentObject(self.teamViewModel)
                    }
                }
            }
        }
    }
}

struct TeamSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSettingsView(isPrivate: false, teamName: "Team Name", description: "Some description here")
            .preferredColorScheme(.light)
            .environmentObject(TeamViewModel())
    }
}
