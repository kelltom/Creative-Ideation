//
//  CreateGroupView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-25.
//

import SwiftUI

struct CreateGroupSheet: View {

    @State var groupTitle: String = ""
    @State var groupDescription: String = ""

    @Binding var showSheets: ActiveSheet?

    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }
            GeometryReader { geometry in
                VStack {

                    Text("Create Your Group").font(.system(size: 40, weight: .heavy)).padding()

                    HStack {

                        VStack {

                            EditTextField(title: "group name", input: $groupTitle, geometry: geometry, widthScale: 0.75)

                            Button {
                                groupViewModel.createGroup(teamId: teamViewModel.selectedTeam?.teamId,
                                                           groupTitle: groupTitle)
                                groupTitle = ""
                            } label: {
                                BigButton(title: "Create", geometry: geometry, widthScale: 0.75).padding()
                            }
                        }

                    }
                    .padding() // padding padding for title
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .banner(data: $groupViewModel.bannerData,
                    show: $groupViewModel.showBanner)
        }
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupSheet(showSheets: .constant(.group))
    }
}
