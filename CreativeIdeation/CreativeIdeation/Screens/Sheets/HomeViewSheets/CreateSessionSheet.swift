//
//  CreateSessionView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI
import Profanity_Filter

struct CreateSessionSheet: View {

    @State var sessionName: String = ""
    @Binding var showSheets: ActiveSheet?
    @Binding var showActivity: Bool

    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel

    var pFilter = ProfanityFilter()

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }

            GeometryReader { geometry in
                VStack {
                    Text("Create a Session")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    VStack {
                        EditTextField(title: "Session Name", input: $sessionViewModel.newSession.sessionTitle, geometry: geometry, widthScale: 0.75)

                        EditTextField(title: "Description", input: $sessionViewModel.newSession.sessionDescription, geometry: geometry, widthScale: 0.75)

                        HStack {
                            ActivityTypeTile(
                                title: "Sticky Notes",
                                symbolName: "doc.on.doc.fill",
                                selected: true)
                                .padding()
                        }

                        Button {
                            sessionViewModel.createSession(teamId: teamViewModel.selectedTeam?.teamId,
                                                           groupId: groupViewModel.selectedGroup?.groupId)
                        } label: {
                            BigButton(title: "Start", geometry: geometry, widthScale: 0.75).padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .banner(data: $sessionViewModel.bannerData,
                    show: $sessionViewModel.showBanner)
        }
        .onChange(of: self.sessionViewModel.didOperationSucceed, perform: { _ in
            if self.sessionViewModel.didOperationSucceed {
                // Load session
                sessionItemViewModel.activeSession = sessionViewModel.newSession
                sessionItemViewModel.loadItems()
                // Reset variables
                showSheets = nil
                showActivity = true
                self.sessionViewModel.didOperationSucceed = false
            }
        })
    }
}

struct CreateSessionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSessionSheet(showSheets: .constant(.session), showActivity: .constant(false))
            .environmentObject(TeamViewModel())
            .environmentObject(GroupViewModel())
            .environmentObject(SessionViewModel())
            .environmentObject(SessionItemViewModel())
    }
}
