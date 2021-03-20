//
//  CodeGeneratorView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-19.
//

import SwiftUI

struct AddTeamMembersView: View {
    
    @Binding var showSheets: ActiveSheet?
    
    @EnvironmentObject var teamViewModel: TeamViewModel
    
    var body: some View {
        
        ZStack {
            
            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }
            
            VStack {
                Text("Team Code")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                
                VStack {
                    HStack {
                        Spacer()
                        Text("tFGT67fF") // temporary value
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Button{
                            
                        }label:{
                            Image(systemName: "doc.on.doc")
                            
                        }
                        
                    }
                    
                }
                .padding()
                .frame(width: 400, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .border(Color.white, width: 1.0)
                .background(Color.white)
                
            }
            .frame(maxWidth: 600, maxHeight: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke(Color("brandPrimary"), lineWidth: 2.5))
            .background(Color("brandPrimary"))
            .cornerRadius(25.0)
        }
        
    }
    
}

struct CodeGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        AddTeamMembersView(showSheets: .constant(.addTeamMembers))
    }
}
