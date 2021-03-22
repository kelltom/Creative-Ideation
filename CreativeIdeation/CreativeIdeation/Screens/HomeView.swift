//
//  GroupView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case team, group, session, addTeamMembers
    
    var id: Int{
        hashValue
    }
}

struct HomeView: View {
    
    @State var activeSheet: ActiveSheet?
    @State var showActivity: Bool = false
    
    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
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
                    groupViewModel.groups = []
                } label: {
                    if teamViewModel.selectedTeam == nil {
                        TeamPic(selected: true, symbol_name: "house", teamName: "Home")
                    } else {
                        TeamPic(selected: false, symbol_name: "house", teamName: "Home")
                    }
                }
                
                // Add buttons for additional Teams
                ForEach(teamViewModel.teams) { team in
                    
                    Button {
                        teamViewModel.selectedTeam = team
                        groupViewModel.selectedGroup = nil
                        groupViewModel.getGroups(teamId: teamViewModel.selectedTeam?.teamId)
                    } label: {
                        if teamViewModel.selectedTeam?.id == team.id {
                            TeamPic(selected: true, teamName: team.teamName)
                        } else {
                            TeamPic(selected: false, teamName: team.teamName)
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
            
            VStack {
                
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
                        
                        RecentSessionList()
                        
                        Divider()
                        
                        HStack(spacing: 0){
                            
                            VStack() {
                                
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
                                                
                                                // TODO: get list of sessions for group here
                                                
                                            } label: {
                                                if group.groupId == groupViewModel.selectedGroup?.groupId {
                                                    GroupButton(title: group.groupTitle, selected: true)
                                                        .padding(.top)
                                                } else {
                                                    GroupButton(title: group.groupTitle, selected: false)
                                                        .padding(.top)
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                }
                                
                                
                            }
                            .frame(width: 230)
                            
                            Divider()
                            
                            VStack {
                                
                                Text("Sessions")
                                    .font(.title)
                                
                                ScrollView(showsIndicators: false) {
                                    
                                    LazyVGrid(columns: columns, spacing: 40){
                                        
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
                                        
                                        SessionItem()
                                        SessionItem()
                                        SessionItem()
                                        SessionItem()
                                        SessionItem()
                                        SessionItem()
                                        SessionItem()
                                        SessionItem()
                                        SessionItem()
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
        .sheet(item: $activeSheet){ item in
            switch item {
            
            case .session:
                CreateSessionView(sessionName: "", showSheets: $activeSheet, showActivity: $showActivity)
                
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
        }
        
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TeamViewModel())
            .environmentObject(GroupViewModel())
    }
}



