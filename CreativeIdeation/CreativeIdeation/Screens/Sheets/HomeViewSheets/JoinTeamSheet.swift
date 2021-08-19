//
//  JoinTeamView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-13.
//

import SwiftUI

struct JoinTeamSheet: View {
    @State private var showBanner: Bool = false
    @Binding var showSheets: ActiveSheet?
    @State var code: String = ""
    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var userTeamModel: UserAccountViewModel
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
            GeometryReader { geometry in
                VStack {
                    Text("Join a Team ")
                        .font(.system(size: 40))
                        .padding()
                    VStack(alignment: .leading) {
                        Text("Enter Your Team Code")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.leading)
                        EditTextField(title: "Team Code", input: $code, geometry: geometry, widthScale: 0.75)
                    }
                    Button {
                        teamViewModel.joinTeam(code: code)
                        code = ""
                    } label: {
                        BigButton(title: "Join", geometry: geometry, widthScale: 0.75)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
struct JoinTeamView_Previews: PreviewProvider {
    static var previews: some View {
        JoinTeamSheet(showSheets: .constant(.joinTeam))
            .preferredColorScheme(.dark)
            .environmentObject(TeamViewModel())
    }
}
