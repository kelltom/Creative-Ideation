//
//  UpdateGroupNameSheet.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-09-18.
//

import SwiftUI
import Profanity_Filter

struct UpdateGroupNameSheet: View {

    @Binding var showSheet: Sheets?

    @State var newName: String = ""
    @State var currentName: String = ""
    @State private var widthScale: CGFloat = 0.75

    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {
        ZStack {

            Color("BackgroundColor")

            if groupViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3)
            }

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

                    // Main title
                    Text("Change Group Name")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    // Fields and headings
                    VStack(alignment: .center) {

                        Text("Current Group Name")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top)
                            .padding(.bottom, 10)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)

                        Text(groupViewModel.selectedGroup?.groupTitle ?? "N/A").foregroundColor(.blue)
                            .padding()
                            .frame(width: geometry.size.width * widthScale, height: 60, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color("StrokeColor")))
                            .font(.title2)
                            .padding(.bottom, 10)

                        Text("New Group Name")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)

                        EditTextField(title: "Enter New Group Name ", input: $newName, geometry: geometry, widthScale: widthScale)
                    }

                    Button {
                        groupViewModel.updateGroupTitle(newTitle: newName, teamId: teamViewModel.selectedTeam?.teamId)
                        newName = ""
                    } label: {
                        BigButton(title: "Submit", geometry: geometry, widthScale: widthScale)
                    }

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .banner(data: $groupViewModel.bannerData,
                    show: $groupViewModel.showBanner)
        }
    }
}

struct UpdateGroupNameSheet_Previews: PreviewProvider {
    static var previews: some View {
        UpdateGroupNameSheet(showSheet: .constant(Sheets.name))
            .environmentObject(GroupViewModel())
            .environmentObject(TeamViewModel())
    }
}
