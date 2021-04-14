//
//  JoinTeamView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-13.
//

import SwiftUI

struct JoinTeamView: View {

    @State private var showBanner: Bool = false
    @Binding var showSheets: ActiveSheet?
    @State var code: String = ""
    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var userTeamModel: UserAccountViewModel

    var body: some View {

        ZStack {

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

                Text("Join a Team ")
                    .font(.system(size: 40))
                    .padding()

                VStack(alignment: .leading) {

                    Text("Enter Your Team Code")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.leading)

                    MenuTextField(title: "team code", input: $code)

                    Button {
//                        teamViewModel.createTeam(teamName: teamName, teamDescription: teamDescription)
//                        teamName = ""
//                        teamDescription = ""
                    } label: {
                        BigButton(title: "Join")

                    }

                }
            }
        }

    }

}

struct JoinTeamView_Previews: PreviewProvider {
    static var previews: some View {
        JoinTeamView(showSheets: .constant(.joinTeam))
            .environmentObject(TeamViewModel())
    }
}
