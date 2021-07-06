//
//  GroupMembersView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-06-05.
//

import SwiftUI

//struct Member: Identifiable, Hashable {
//    let name: String
//    let id = UUID()
//}

struct GroupMembersView: View {

    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel

    @Binding var showSheets: ActiveSheet?
    @State private var members: [Member] = []
    @State private var editMode: EditMode = .active
    @State private var multiSelection = Set<UUID>()

    var body: some View {
        ZStack {

            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }
            VStack {
                List(members, selection: $multiSelection) {
                    Text($0.name)
                        .font(.title)
                }
                .frame(width: 450, height: 600)
                .environment(\.editMode, self.$editMode)
//                .onAppear(perform: {
//                    members = groupViewModel.getMembersNotInGroup(teamId: teamViewModel.selectedTeam?.teamId)
//                })
            }
        }
    }
}

struct GroupMembersView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMembersView(showSheets: .constant(.session))
            .environmentObject(GroupViewModel())
            .environmentObject(TeamViewModel())
    }
}
