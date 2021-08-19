//
//  CreateSessionView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct CreateSessionSheet: View {

    @State var sessionName: String = ""
    @Binding var showSheets: ActiveSheet?
    @Binding var showActivity: Bool

    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }

            GeometryReader { geometry in
                VStack {
                    Text("Create a Session").font(.system(size: 40, weight: .heavy)).padding()

                    VStack {
                        EditTextField(title: "Session Name", input: $sessionViewModel.newSession.sessionTitle, geometry: geometry, widthScale: 0.75)

                        EditTextField(title: "Description", input: $sessionViewModel.newSession.sessionDescription, geometry: geometry, widthScale: 0.75)

                        HStack {
    //                        ActivityTypeTile(selected: true)
    //                            .padding()
                            ActivityTypeTile(
                                title: "Sticky Notes",
                                symbolName: "doc.on.doc.fill",
                                selected: true)
                                .padding()
                        }

                        Button {
                            sessionViewModel.createSession(teamId: teamViewModel.selectedTeam?.teamId,
                                                           groupId: groupViewModel.selectedGroup?.groupId)
                            sessionItemViewModel.activeSession = sessionViewModel.newSession
                            sessionItemViewModel.loadItems()
                            showSheets = nil
                            showActivity = true
                        } label: {
                            BigButton(title: "Start", geometry: geometry, widthScale: 0.75).padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
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
