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
    var teamName: String = "My Team"
    var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    
    @State private var profanityFilter = true
    @State var showSheet: EditSheet?
    

    /// Indicates whether current Team is private, which disables/enables certain fields
    var isPrivate: Bool

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

                                Text(teamName)
                                    .font(.title3)

                                Spacer()

                                Button {
                                    // button functionality
                                } label: {
                                    // button design
                                    TextEditButton()
                                }
                            }

                            Text("Description")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                            HStack {

                                Text(description)
                                    .font(.title3)

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
                        .frame(width: geometry.size.width * 0.63, height: 340, alignment: .leading)
                        
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)

                    }
                    .frame(width: geometry.size.width * 0.7,height: 500, alignment: .center)
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
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct TeamSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSettingsView(teamName: "Team Name", description: "Some description here", isPrivate: false)
            .preferredColorScheme(.light)
            .environmentObject(TeamViewModel())
    }
}
