//
//  UpdateTeamMembersSheet.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-11-14.
//

import SwiftUI

struct UpdateTeamMembersSheet: View {

    @State var isAdmin: Bool

    @State private var multiSelection = Set<String>()
    @State private var editMode: EditMode = .active  // Determined by admin status

    @Binding var showSheet: EditSheet?

    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            // Exit button
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

            // Main page content
            GeometryReader { geometry in

                VStack {

                    Spacer()
                        .frame(height: geometry.size.height * 0.1)

                    // Main title
                    Text("Team Members")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    if teamViewModel.teamMembers.count <= 1 {
                        Text("You're the only one in the Team. Consider inviting more members!")
                            .padding(.top, 20)
                        Spacer()
                    } else {
                        // Multi-select view
                        List(teamViewModel.teamMembers, selection: $multiSelection) {
                            Text($0.name)
                                .font(.title2)
                        }
                        .cornerRadius(15)
                        .environment(\.editMode, self.$editMode)
                        .frame(width: geometry.size.width * 0.75)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke())

                        // Remove Member button
                        if isAdmin {
                            Button {
                                teamViewModel.removeMembers(memberIds: multiSelection)
                                multiSelection.removeAll()
                            } label: {
                                DeleteButton(text: "Remove Member(s)",
                                             image: "")
                            }
                        }
                        Spacer()
                            .frame(height: geometry.size.height * 0.1)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .banner(data: $teamViewModel.bannerData,
                    show: $teamViewModel.showBanner)

            if teamViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3)
            }
        }
        .onAppear {

            // Determine admin status, set edit mode accordingly
            if !isAdmin {
                editMode = .inactive
            }
        }
    }
}

struct UpdateTeamMembersSheet_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTeamMembersSheet(isAdmin: true, showSheet: .constant(.members))
    }
}
