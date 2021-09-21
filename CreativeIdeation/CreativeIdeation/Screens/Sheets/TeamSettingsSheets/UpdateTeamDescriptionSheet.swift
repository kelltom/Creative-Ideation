//
//  UpdateTeamDescriptionSheet.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-09-18.
//

import SwiftUI

struct UpdateTeamDescriptionSheet: View {
    @State var newTeamDescription: String = ""
    @State var currentTeamName: String = ""
    @State private var widthScale: CGFloat = 0.75
    @Binding var showSheet: EditSheet?

    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            if teamViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3).padding()
            }

            VStack {

                HStack {

                    Spacer()

                    Button {
                        showSheet = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.label))
                            .imageScale(.large)
                            .frame(width: 80, height: 80)
                    }
                }
                .padding()

                Spacer()
            }

            GeometryReader { geometry in

                VStack {

                    Spacer()

                    Text("Change Team Description")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.top)

                    VStack(alignment: .center) {

                        Text("Current Team Description")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top)
                            .padding(.bottom, 10)
                            .frame(width: geometry.size.width * 0.75, alignment: .leading)

                        Text(teamViewModel.selectedTeam?.teamDescription ?? "N/A")
                            .padding()
                            .frame(width: geometry.size.width * 0.75, height: 60, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color("StrokeColor")))
                            .font(.title2)
                            .padding(.bottom, 10)

                        Text("New Team Description")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top)
                            .frame(width: geometry.size.width * 0.75, alignment: .leading)

                        EditTextField(title: "Enter New Team Name ", input: $newTeamDescription, geometry: geometry, widthScale: widthScale)
                    }

                    Button {
                        teamViewModel.updateSelectedTeamDescription(teamDescription: newTeamDescription)
                        newTeamDescription = ""

                    } label: {
                        BigButton(title: "Submit", geometry: geometry, widthScale: 0.75)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .banner(data: $teamViewModel.bannerData,
                    show: $teamViewModel.showBanner)
        }
        .onAppear {
            teamViewModel.showBanner = false
        }
    }
}

struct UpdateTeamDescriptionSheet_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTeamDescriptionSheet(showSheet: .constant(.description))
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            .environmentObject(TeamViewModel())
    }
}
