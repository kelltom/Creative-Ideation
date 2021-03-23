//
//  CreateSessionView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct CreateSessionView: View {
    
    @State var sessionName: String = ""
    @Binding var showSheets: ActiveSheet?
    @Binding var showActivity: Bool
    
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel
    
    var body: some View {
        
        ZStack {
            
            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }
            
            VStack{
                Text("Create a Session").font(.system(size: 40, weight: .heavy)).padding()
                
                VStack{
                    MenuTextField(title: "Session Name", input: $sessionViewModel.newSession.sessionTitle)
                    
                    MenuTextField(title: "Description", input: $sessionViewModel.newSession.sessionDescription)
                    
                    HStack{
                        ActivityTypeTile(selected: true)
                            .padding()
                        ActivityTypeTile(
                            title: "Sticky Notes", symbol_name: "doc.on.doc.fill")
                            .padding()
                    }
                    
                    Button {
                        sessionViewModel.createSession(teamId: teamViewModel.selectedTeam?.teamId, groupId: groupViewModel.selectedGroup?.groupId)
                        showSheets = nil
                        showActivity = true
                    } label: {
                        BigButton(title: "Start").padding()
                    }
                }
            }
        }
    }
}

struct CreateSessionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSessionView(showSheets: .constant(.session), showActivity: .constant(false))
    }
}
