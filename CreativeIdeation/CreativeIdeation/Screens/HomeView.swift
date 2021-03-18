//
//  GroupView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct HomeView: View {
    
    @State var showCreateTeam = false
    @State var selection: Int? = nil
    
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
                    showCreateTeam = true
                    
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
                    
                    Button {
                        // view user prefs
                    } label: {
                        ProfilePic(size: 70)
                            .shadow(color: .black, radius: 4, y: 4)
                    }
                }
                .padding()
                
                Divider()
                
                VStack{
                    VStack(alignment: .leading){
                        HStack{
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
                            VStack(){
                                Text("Groups")
                                    .font(.title)
                                
                                SubGroupsList()
                            }
                            .frame(width: 230)
                            
                            Divider()
                            
                            VStack{
                                Text("Sessions")
                                    .font(.title)
                                
                                SessionsList()
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                
            }
        }
        .navigationTitle("Home")
        .navigationBarHidden(true)
        .sheet(isPresented: $showCreateTeam){
            CreateTeamView(showCreateTeam: $showCreateTeam, bannerMsg: "", bannerColor: .white, bannerImage: "")
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



