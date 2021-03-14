//
//  GroupSidebar.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct GroupSidebar: View {
    
    
    var body: some View {
        
        VStack {
            
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
            
            Button{
                // Add group button
                
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
        .background(Color("darkCyan"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct GroupSidebar_Previews: PreviewProvider {
    static var previews: some View {
        GroupSidebar()
    }
}
