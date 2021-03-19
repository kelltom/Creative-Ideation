//
//  CreateTeamsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-24.
//

import SwiftUI
import Firebase


struct CreateTeamView: View {
    
    @State private var showBanner: Bool = false
    @Binding var showSheets: ActiveSheet?
    
    @EnvironmentObject var teamViewModel: TeamViewModel
    
    var body: some View {
        
        ZStack {
            
            if teamViewModel.showBanner {
                if teamViewModel.createSuccess {
                    NotificationBanner(image: "checkmark.circle.fill", msg: teamViewModel.msg, color: .green)
                } else {
                    NotificationBanner(image: "exclamationmark.circle.fill", msg: teamViewModel.msg, color: .red)
                }
            }

            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }
            
            VStack {
                
                Text("Create Your Team")
                    .font(.system(size: 40))
                    .padding()
                
                VStack {
                    
                    MenuTextField(title: "Team name", input: $teamViewModel.newTeam.teamName)
                    
                    MenuTextField(title: "Team description (optional)", input: $teamViewModel.newTeam.teamDescription)
                    
                    Button {
                        teamViewModel.createTeam()
                    } label: {
                        BigButton(title: "Create")
                            .padding(.top, 5)
                    }
                    
                    Text("or")
                        .hidden()
                    
                    // Create Acc Button
                    NavigationLink(destination: EmptyView()) {
                        Text("Reactivate pre-existing team.")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.top)
                    .hidden()
                    
                }
            }
        }
        
    }
    
    private func delayAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation{
                showBanner = false
            }
        }
    }
}

struct CreateTeamView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTeamView(showSheets: .constant(.team))
    }
}
