//
//  GroupMembersView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-06-05.
//

import SwiftUI

struct GroupMembersSheet: View {

    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel

    @Binding var showSheets: ActiveSheet?
    @State private var members: [Member] = []
    @State private var editMode: EditMode = .active
    @State private var multiSelection = Set<String>()

    var body: some View {
        ZStack {

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
                List(members, selection: $multiSelection) {
                    Text($0.name)
                        .font(.title2)
                }
                .environment(\.editMode, self.$editMode)
                .frame(width: 450, height: 600)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke())

                Button {
                    groupViewModel.addMembers(teamId: teamViewModel.selectedTeam?.teamId,
                                              memberIds: multiSelection)
                    groupViewModel.splitMembers(teamMembers: teamViewModel.teamMembers)

                } label: {
                    Text("Add Selected Members")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 450)
                        .background(Color("brandPrimary"))
                        .cornerRadius(10)
                        .clipped()
                        .shadow(radius: 5, x: 5, y: 5)
                        .padding(.top, 20)
                }
            }
        }
        .onAppear(perform: {
            members = groupViewModel.nonMembers
        })
    }
}

struct GroupMembersView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMembersSheet(showSheets: .constant(.addGroupMembers))
            .environmentObject(GroupViewModel())
            .environmentObject(TeamViewModel())
    }
}
