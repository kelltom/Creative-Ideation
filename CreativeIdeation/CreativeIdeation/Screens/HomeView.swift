//
//  GroupView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case team, group, session, addTeamMembers

    var id: Int {
        hashValue
    }
}

struct HomeView: View {

    @State var activeSheet: ActiveSheet?
    @State var showActivity: Bool = false

    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel

    let columns = [
        GridItem(.adaptive(minimum: 200))]

    var body: some View {

        HStack(spacing: 0) {

            VStack {

                Text("Teams")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Home Team button
                Button {
                    teamViewModel.selectedTeam = nil
                } label: {
                    TeamPic(selected: teamViewModel.selectedTeam == nil,
                            symbolName: "house",
                            teamName: "Home")
                }

                // Add buttons for additional Teams
                ForEach(teamViewModel.teams) { team in

                    Button {
                        teamViewModel.selectedTeam = team
                    } label: {
                        TeamPic(selected: teamViewModel.selectedTeam?.id == team.id,
                                teamName: team.teamName)
                    }.contextMenu {
                        Button {
                            // Delete selected team
                            teamViewModel.deleteSelectedTeam()
                        } label: {
                            HStack {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                        }
                    }
                }

                // Add/Join Team Button
                Button {
                    activeSheet = .team
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.white)
                        .padding()
                }

                Spacer()
            }
            .frame(maxHeight: .infinity)
            .background(Color("brandPrimary"))
            .edgesIgnoringSafeArea(.all)

            // Mid Screen
            VStack {

                // Top Title Bar
                HStack(spacing: 20) {
                    Text(teamViewModel.selectedTeam?.teamName ?? "Home")
                        .font(.largeTitle)

                    Button {
                        // add person to group
                        activeSheet = .addTeamMembers
                    } label: {
                        Image(systemName: "person.badge.plus.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.black)
                    }

                    NavigationLink(
                        destination: TeamSettingsView(),
                        label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.black)
                        })

                    Spacer()

                    Button {
                        // view notifications
                    } label: {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.yellow)
                    }

                    NavigationLink(
                        destination: UserSettingsView(),
                        label: {
                            ProfilePic(size: 70)
                                .shadow(color: .black, radius: 4, y: 4)

                        })

                }
                .padding()

                Divider()

                VStack {

                    // Recent Sessions List
                    VStack(alignment: .leading) {

                        HStack {
                            Text("Recent Sessions")
                                .font(.title)

                            Image(systemName: "clock.arrow.circlepath")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.red)

                            Spacer()

                            GroupMemberPanel()
                                .hidden()

                        }
                        .padding(.leading)

                        // Generate list of recent Sessions for Team
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 50) {
                                ForEach(sessionViewModel.teamSessions) { session in
                                    Button {
                                        // make session clickable
                                    } label: {
                                        SessionTile(team: teamViewModel.selectedTeam?.teamName ?? "N/A",
                                                    group: groupViewModel.groups.first(
                                                        where: {$0.groupId == session.groupId})?.groupTitle ?? "N/A",
                                                    session: session)
                                    }
                                }
                            }
                            .padding(.leading)
                        }
                        .frame(maxHeight: 225)

                        Divider()

                        HStack(spacing: 0) {

                            VStack {

                                Text("Groups")
                                    .font(.title)

                                // Add Group button
                                Button {
                                    activeSheet = .group
                                } label: {
                                    Text("Add Group")
                                        .foregroundColor(Color.black)
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 15)
                                }

                                // Groups Column
                                ScrollView {

                                    LazyVStack {

                                        ForEach(groupViewModel.groups) { group in

                                            Button {
                                                if groupViewModel.selectedGroup?.id == group.id {
                                                    // if already selected, un-select
                                                    groupViewModel.selectedGroup = nil
                                                } else {
                                                    groupViewModel.selectedGroup = group
                                                }
                                            } label: {
                                                GroupButton(
                                                    title: group.groupTitle,
                                                    selected: group.groupId == groupViewModel.selectedGroup?.groupId)
                                                    .padding(.top)
                                            }
                                        }

                                    }
                                }

                            }
                            .frame(width: 230)

                            Divider()

                            // Sessions Column
                            VStack {

                                Text("Sessions")
                                    .font(.title)

                                // List of Sessions
                                ScrollView(showsIndicators: false) {

                                    LazyVGrid(columns: columns, spacing: 40) {

                                        // Create Session button
                                        Button {
                                            activeSheet = .session
                                        } label: {
                                            Image(systemName: "plus")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                                .frame(width: 200, height: 200)
                                                .overlay(RoundedRectangle(cornerRadius: 25.0)
                                                            .stroke(Color.black, lineWidth: 2.0))
                                        }

                                        // Generate list of Sessions for selected group
                                        ForEach(sessionViewModel.groupSessions) { session in

                                            Button {
                                                // make session clickable
                                                sessionItemViewModel.activeSession = session
                                                sessionItemViewModel.loadItems()
                                                showActivity = true
                                            } label: {
                                                SessionTile(
                                                    team: teamViewModel.selectedTeam?.teamName ?? "Unknown",
                                                    group: groupViewModel.selectedGroup?.groupTitle ?? "Unknown",
                                                    session: session)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .padding(.top)
                            }
                        }

                    }
                    .frame(maxWidth: .infinity)
                }

            }

            NavigationLink(destination: ActivityView(
                            showActivity: self.$showActivity), isActive: self.$showActivity) {
                EmptyView()
            }
        }
        .navigationTitle("Home")
        .navigationBarHidden(true)
        .sheet(item: $activeSheet) { item in
            switch item {

            case .session:
                CreateSessionView(sessionName: "", showSheets: $activeSheet, showActivity: $showActivity)
                    .environmentObject(self.groupViewModel)
                    .environmentObject(self.teamViewModel)
                    .environmentObject(self.sessionViewModel)

            case .team:
                CreateTeamView(showSheets: $activeSheet)
                    .environmentObject(self.teamViewModel)

            case .addTeamMembers:
                AddTeamMembersView(showSheets: $activeSheet)
                    .environmentObject(self.teamViewModel)

            case .group:
                CreateGroupView(showSheets: $activeSheet)
                    .environmentObject(self.teamViewModel)
                    .environmentObject(self.groupViewModel)

            }
        }
        .onAppear {
            teamViewModel.getTeams()
            sessionViewModel.getAllSessions(teamId: teamViewModel.selectedTeam?.teamId)
            sessionViewModel.getGroupSessions(groupId: groupViewModel.selectedGroup?.groupId)
        }
        .onChange(of: teamViewModel.selectedTeam) {_ in
            groupViewModel.selectedGroup = nil
            groupViewModel.getGroups(teamId: teamViewModel.selectedTeam?.teamId)
            sessionViewModel.getAllSessions(teamId: teamViewModel.selectedTeam?.teamId)
            sessionViewModel.getGroupSessions(groupId: groupViewModel.selectedGroup?.groupId)
        }
        .onChange(of: groupViewModel.selectedGroup) { _ in
            sessionViewModel.getGroupSessions(groupId: groupViewModel.selectedGroup?.groupId)
        }

    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TeamViewModel())
            .environmentObject(GroupViewModel())
            .environmentObject(SessionViewModel())
            .environmentObject(SessionItemViewModel())
    }
}
