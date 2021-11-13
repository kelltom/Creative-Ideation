//
//  GroupView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI
import zlib

enum ActiveSheet: Identifiable {
    case team, group, session, addTeamMembers, joinTeam, addGroupMembers
    
    var id: Int {
        hashValue
    }
}

struct HomeView: View {
    
    @State var isCollapsed: Bool = true
    
    @State var activeSheet: ActiveSheet?
    @State var showActivity: Bool = false
    @State var showGroupSettings: Bool = false
    @State var showUserSettings: Bool = false
    @State var showChatbot: Bool = false
    @State var name: String =  ""
    
    private let shadowColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)
    
    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel
    @EnvironmentObject var userAccountViewModel: UserAccountViewModel
    @EnvironmentObject var sessionSettingsViewModel: SessionSettingsViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    /// Temporary way to show conditional views in preview canvas
    var preview: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 200))]
    
    var body: some View {
        
        ZStack {
            
            Color("BackgroundColor")
            
            HStack(spacing: 0) {
                
                VStack {
                    
                    Text("Teams")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.horizontal, 10)
                    
                    // Add buttons for Teams
                    ForEach(teamViewModel.teams) { team in
                        Button {
                            teamViewModel.selectTeam(team: team)
                        } label: {
                            TeamPic(selected: teamViewModel.selectedTeam?.id == team.id,
                                    teamName: team.teamName)
                        }
                        .contextMenu {
                            Button {
                                // Delete selected team
                                teamViewModel.deleteSelectedTeam(teamId: team.teamId)
                            } label: {
                                HStack {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    
                    // PLUS BUTTON TO ADD OR CREATE TEAM
                    Menu {
                        Button("Create Team", action: {
                            activeSheet = .team
                        })
                        Button("Join Team", action: {
                            activeSheet = .joinTeam
                        })
                    } label: {
                        
                        Image(systemName: "plus.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 45)
                            .padding()
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .background(Color("brandPrimary"))
                .edgesIgnoringSafeArea(.all)
                
                // Mid Screen
                VStack {
                    
                    // Top Title Bar
                    HStack(spacing: 20) {
                        Text(teamViewModel.selectedTeam?.teamName ?? "No Team Selected")
                            .lineLimit(1)
                            .font(.largeTitle)
                        
                        // Add Members and Settings Gear (do not display if selected Team nil)
                        if teamViewModel.selectedTeam?.id != nil {
                            // Add Members Button
                            Button {
                                activeSheet = .addTeamMembers
                            } label: {
                                Image(systemName: "person.badge.plus.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(teamViewModel.selectedTeam?.isPrivate ?? true ?
                                                     Color("FadedColor") : Color("StrokeColor"))
                            }
                            .disabled(teamViewModel.selectedTeam?.isPrivate ?? true)
                            
                            // Team Settings Button
                            NavigationLink(
                                destination: TeamSettingsView(isPrivate: teamViewModel.selectedTeam?.isPrivate ?? true),
                                label: {
                                    Image(systemName: "gearshape.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color("StrokeColor"))
                                })
                        }
                        
                        Spacer()
                        
                        // User Profile Icon
                        if userAccountViewModel.currentImage == nil {
                            Button {
                                showUserSettings = true
                                
                            } label: {
                                ProfilePic(size: 60)
                                    .shadow(color: .black, radius: 4, y: 4)
                                    .padding(.trailing, 5)
                            }
                        } else {
                            Button {
                                showUserSettings = true
                                
                            } label: {
                                userAccountViewModel.currentImage?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }
                        }
                        
                    }
                    .padding()
                    
                    Divider()
                        .background(Color("FadedColor"))
                    
                    // Below title bar (preview variable temporary)
                    if preview || teamViewModel.selectedTeam?.id != nil {
                        VStack {
                            
                            // Recent Sessions List
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack(spacing: 20) {
                                    Text("Recent Sessions")
                                        .font(.title)
                                    
                                    // Button for collapsing/expanding the recent sessions panel
                                    Button {
                                        withAnimation {
                                            isCollapsed.toggle()
                                            
                                        }
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 45, height: 45)
                                                .foregroundColor(Color("brandPrimary"))
                                            
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(Color.white)
                                                .padding(.leading, 4)
                                                .rotationEffect(Angle.degrees(isCollapsed ? 0 : 90))
                                                .animation(.easeInOut)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    GroupMemberPanel()
                                        .hidden()
                                    
                                }
                                .padding(.leading)
                                
                                // Generate list of recent Sessions for Team
                                if !isCollapsed {
                                    VStack {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            LazyHStack(spacing: 50) {
                                                ForEach(sessionViewModel.teamSessions) { session in
                                                    Button {
                                                        sessionItemViewModel.activeSession = session
                                                        sessionViewModel.selectedSession = session
                                                        sessionItemViewModel.loadItems()
                                                        showActivity = true
                                                    } label: {
                                                        SessionTile(team: teamViewModel.selectedTeam?.teamName ?? "N/A",
                                                                    group: groupViewModel.groups
                                                                        .first(where: {
                                                            $0.groupId == session.groupId
                                                        })?.groupTitle ?? "N/A",
                                                                    session: session)
                                                    }
                                                }
                                            }
                                            .padding(.leading)
                                        }
                                        .frame(maxHeight: 225)
                                    }
                                    .transition(
                                        .asymmetric(insertion:
                                                            .opacity
                                                        .animation(.easeInOut(duration: 0.5)),
                                                    removal:
                                                            .slide
                                                        .animation(.easeInOut(duration: 0.15))
                                                        .combined(with: .scale(scale: 0.1, anchor: .topTrailing)
                                                                    .animation(.easeInOut(duration: 0.25)))))
                                }
                                
                                Divider()
                                    .background(Color("FadedColor"))
                                
                                HStack(spacing: 0) {
                                    
                                    VStack {
                                        
                                        Text("Groups")
                                            .font(.title)
                                        
                                        // Add Group button
                                        Button {
                                            activeSheet = .group
                                        } label: {
                                            Text("Add Group")
                                            Image(systemName: "plus")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 15)
                                        }
                                        .foregroundColor(Color("StrokeColor"))
                                        
                                        // Groups Column
                                        ScrollView {
                                            
                                            LazyVStack(spacing: 20) {
                                                
                                                ForEach(groupViewModel.groups) { group in
                                                    
                                                    Button {
                                                        if groupViewModel.selectedGroup?.id != group.id {
                                                            groupViewModel.selectedGroup = group
                                                            groupViewModel.splitMembers(teamMembers: teamViewModel.teamMembers)
                                                        }
                                                    } label: {
                                                        GroupButton(
                                                            title: group.groupTitle,
                                                            selected: group.groupId == groupViewModel.selectedGroup?.groupId)
                                                    }
                                                    .contextMenu {
                                                        // Group Settings
                                                        Button {
                                                            groupViewModel.setSelectedGroup(group: group)
                                                            showGroupSettings = true
                                                        } label: {
                                                            HStack {
                                                                Text("Settings")
                                                                Image(systemName: "gearshape.fill")
                                                            }
                                                        }
                                                        
                                                        if groupViewModel.isCurrentUserAdmin(groupId: group.groupId) {
                                                            Button {
                                                                // Delete group
                                                                groupViewModel.deleteGroups(groupId: group.groupId, teamId: teamViewModel.selectedTeam?.teamId ?? "unknown")
                                                            } label: {
                                                                HStack {
                                                                    Text("Delete")
                                                                    Image(systemName: "trash")
                                                                }
                                                            }
                                                        } else {
                                                            Button {
                                                                // Leave group
                                                                groupViewModel.leaveGroup(group: group)
                                                            } label: {
                                                                HStack {
                                                                    Text("Leave")
                                                                    Image(systemName: "rectangle.lefthalf.inset.fill.arrow.left")
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: 230)
                                    
                                    Divider()
                                        .background(Color("FadedColor"))
                                    
                                    // Sessions Column
                                    VStack {
                                        
                                        ZStack {
                                            Text("Sessions")
                                                .font(.title)
                                        }
                                        
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
                                                        .foregroundColor(Color("StrokeColor"))
                                                        .overlay(RoundedRectangle(cornerRadius: 25.0)
                                                                    .stroke(Color("StrokeColor"), lineWidth: 2.0))
                                                }
                                                
                                                // Generate list of Sessions for selected group
                                                ForEach(sessionViewModel.groupSessions) { session in
                                                    
                                                    Button {
                                                        // make session clickable
                                                        sessionItemViewModel.activeSession = session
                                                        sessionViewModel.selectedSession = session
                                                        sessionSettingsViewModel.loadSettings(sessionId: session.sessionId)
                                                        sessionItemViewModel.loadItems()
                                                        showActivity = true
                                                    } label: {
                                                        SessionTile(
                                                            team: teamViewModel.selectedTeam?.teamName ?? "Unknown",
                                                            group: groupViewModel.selectedGroup?.groupTitle ?? "Unknown",
                                                            session: session)
                                                    }
                                                    .contextMenu {
                                                        // Session Settings
                                                        Button {
                                                            sessionViewModel.deleteSession(sessionId: session.sessionId)
                                                        } label: {
                                                            HStack {
                                                                Text("Delete")
                                                                Image(systemName: "trash")
                                                            }
                                                        }
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
                    } else {
                        TutorialOverlay()
                    }
                    
                }
                
                NavigationLink(destination: ActivityView(
                    timerManager: sessionViewModel.timerManager, showActivity: self.$showActivity), isActive: self.$showActivity) {
                        EmptyView()
                    }
                
                NavigationLink(destination: GroupSettingsView(showGroupSettings: $showGroupSettings),
                               isActive: self.$showGroupSettings) {
                    EmptyView()
                }
                
                NavigationLink(destination: UserSettingsView(showUserSettings: self.$showUserSettings),
                               isActive: self.$showUserSettings) {
                    EmptyView()
                }
                
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .sheet(item: $activeSheet) { item in
                switch item {
                    
                case .session:
                    CreateSessionSheet(showSheets: $activeSheet, showActivity: $showActivity)
                        .environmentObject(self.groupViewModel)
                        .environmentObject(self.teamViewModel)
                        .environmentObject(self.sessionViewModel)
                    
                case .team:
                    CreateTeamSheet(showSheets: $activeSheet)
                        .environmentObject(self.teamViewModel)
                        .environmentObject(self.groupViewModel)
                    
                case .addTeamMembers:
                    TeamCodeSheet(showSheets: $activeSheet)
                        .environmentObject(self.teamViewModel)
                    
                case .addGroupMembers:
                    GroupMembersSheet(showSheets: $activeSheet)
                        .environmentObject(self.teamViewModel)
                        .environmentObject(self.groupViewModel)
                    
                case .group:
                    CreateGroupSheet(showSheets: $activeSheet)
                        .environmentObject(self.teamViewModel)
                        .environmentObject(self.groupViewModel)
                    
                case .joinTeam:
                    JoinTeamSheet(showSheets: $activeSheet)
                        .environmentObject(self.teamViewModel)
                        .environmentObject(self.userAccountViewModel)
                    
                }
            }
            .onChange(of: teamViewModel.selectedTeam) {_ in
                groupViewModel.clear()
                groupViewModel.getGroups(teamId: teamViewModel.selectedTeam?.teamId)
                sessionViewModel.clear()
                sessionViewModel.getAllSessions(teamId: teamViewModel.selectedTeam?.teamId)
                sessionViewModel.getGroupSessions()
            }
            .onChange(of: groupViewModel.selectedGroup) { _ in
                sessionViewModel.selectedGroupId = groupViewModel.selectedGroup?.groupId
                sessionViewModel.getGroupSessions()
                
            }
            // Chatbot
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if showChatbot {
                        // Actual Chatbot
                        ChatbotView(showChatbot: $showChatbot)
                            .padding(20)
                            .animation(.easeInOut)
                    } else {
                        // Chatbot Button
                        Button {
                            withAnimation {
                                showChatbot = true
                            }
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(colorScheme == .dark ? .blue.lighter(by: 20) : .blue)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .padding(20)
                        }
                    }
                }
            }
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.light)
            .environmentObject(TeamViewModel())
            .environmentObject(GroupViewModel())
            .environmentObject(SessionViewModel())
            .environmentObject(SessionItemViewModel())
    }
}
