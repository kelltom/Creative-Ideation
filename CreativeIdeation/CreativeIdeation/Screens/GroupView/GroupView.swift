//
//  GroupView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct GroupView: View {
    
    @State private var listExpanded: Bool = true
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            GroupSidebar()
            
            VStack{
                HStack(spacing: 20){
                    Text("Example Company")
                        .font(.largeTitle)
                    
                    
                    Button{
                        // add person to group
                    } label: {
                        Image(systemName: "person.badge.plus.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.black)
                    }
                    
                    Button{
                        // change group prefs
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.black)
                    }
                    
                    Spacer()
                    
                    Button{
                        // view notifications
                    } label: {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.yellow)
                    }
                    
                    Button{
                        // view user prefs
                    } label: {
                        ProfilePic(size: 70)
                            .shadow(color: .black, radius: 4, y: 4)
                    }
                }
                .padding()
                
                Divider()
                
                VStack{
//                    DisclosureGroup(isExpanded: $listExpanded) {
//                        HStack{
//                            VStack{
//                                Text("Favourite Sessions")
//                                    .font(.largeTitle)
//
//                                Divider()
//
//                                RecentSessionList()
//
//                            }
//
//                            VStack{
//                                Text("Sub Groups")
//                                    .font(.largeTitle)
//
//                                Divider()
//
//                                SubGroupsList()
//                            }
//                        }
//                    } label: {
//                        Spacer()
//                        Text("Menu")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                    }
//                    .padding()
                    
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
                            
                        }
                        .padding()
                        
                        RecentSessionList()
                        
                        Divider()
                        
                        HStack(spacing: 0){
                            VStack(){
                                Text("Groups")
                                    .font(.title)
                                    .padding()
                                
                                SubGroupsList()
                            }
                            .frame(width: 230)
                            
                            Divider()
                            
                            VStack{
                                Text("Sessions")
                                    .font(.title)
                                    .padding()
                                
                                SessionsList()
                            }
                        }
                        
                       
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                
                //Spacer()
                
            }
        }
        .navigationTitle("Home")
        .navigationBarHidden(true)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
