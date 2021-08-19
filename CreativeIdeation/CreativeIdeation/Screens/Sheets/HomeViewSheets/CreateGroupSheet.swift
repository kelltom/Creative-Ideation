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

            if groupViewModel.isShowingBanner {
                if groupViewModel.didOperationSucceed {
                    NotificationBanner(image: "checkmark.circle.fill", msg: groupViewModel.msg, color: .green)
                } else {
                    NotificationBanner(image: "exclamationmark.circle.fill", msg: groupViewModel.msg, color: .red)
                }
            }

            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }

            VStack {

                Text("Create Your Group").font(.system(size: 40, weight: .heavy)).padding()

                HStack {

                    VStack {

                        MenuTextField(title: "group name", input: $groupTitle)

                        Button {
                            groupViewModel.createGroup(teamId: teamViewModel.selectedTeam?.teamId,
                                                       groupTitle: groupTitle)
                            groupTitle = ""
                        } label: {
                            BigButton(title: "Create").padding()
                        }
                    }

                }
                .padding() // padding padding for title
            }
        }
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupSheet(showSheets: .constant(.group))
    }
}
