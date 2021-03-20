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
    
    let columns = [
        GridItem(.adaptive(minimum: 200))]
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            VStack{
                
                Text("Teams")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                GroupPic(symbol_name: "house.circle")
                    .padding()
                
                GroupPic(selected: true)
                    .padding()
                
                GroupPic()
                    .padding()
                
                Button {
                    // Add group button
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
                
                HStack(spacing: 20){
                    Text("Example Company")
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
                        destination: UserPrefView(),
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
                        .padding(.horizontal, 10)
                        
                        RecentSessionList()
                        
                        Divider()
                        
                        HStack(spacing: 0){
                            
                            VStack() {
                                
                                Text("Groups")
                                    .font(.title)
                                
                                VStack {
                                    
                                    Button {
                                        activeSheet = .group
                                    } label: {
                                        Text("Add Group")
                                            .foregroundColor(Color.black)
                                        Image(systemName: "plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 15)
                                            .padding()
                                    }
                                }.padding()
                                                                
                                SubGroupsList()
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
                
            case .addTeamMembers:
                AddTeamMembersView(showSheets: $activeSheet)
                
            case .group:
                CreateGroupView(showSheets: $activeSheet)
                
            }
        }
        
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



