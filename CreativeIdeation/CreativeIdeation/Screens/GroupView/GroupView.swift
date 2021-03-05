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
                        .font(.system(size: 48))
                    
                    
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
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.yellow)
                    }
                    
                    Button{
                        // view user prefs
                    } label: {
                        ProfilePic(size: 90)
                            .shadow(color: .black, radius: 4, y: 4)
                    }
                }
                .padding()
                
                Divider()
                
                VStack{
                    DisclosureGroup(isExpanded: $listExpanded) {
                        HStack{
                            VStack{
                                Text("Favourite Sessions")
                                    .font(.largeTitle)
                                
                                Divider()
                                
                                RecentSessionList()
                                
                            }
                            
                            VStack{
                                Text("Sub Groups")
                                    .font(.largeTitle)
                                
                                Divider()
                                
                                SubGroupsList()
                            }
                        }
                    } label: {
                        Spacer()
                        Text("Menu")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading){
                        HStack{
                            VStack(alignment: .leading){
                                Text("Marketing")
                                    .font(.system(size: 48))
                                    .fontWeight(.bold)
                                
                                Text("Created on Feb.25th by Kell Evoy")
                                    .font(.title3)
                            }
                            
                            Button{
                                // change sub group prefs
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.black)
                                    .padding()
                            }
                            
                            Spacer()
                            
                            GroupMemberPanel()
                            
                        }
                        .padding()
                        
                        Text("Description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text description text")
                            .font(.title3)
                            .padding()
                        
                        Text("Sessions")
                            .font(.system(size: 40))
                            .padding()
                        
                        SessionsList()
                            .padding()
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Spacer()
                
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
