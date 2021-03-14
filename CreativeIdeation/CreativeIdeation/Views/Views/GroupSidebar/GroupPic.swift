//
//  GroupPic.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct GroupPic: View {
    
    var selected: Bool = false
    var symbol_name: String = "person.3.fill"
    var team_name: String = "Example"
    
    var body: some View {
        VStack{
            Button {
                // select group
            } label: {
                if selected{
                    Image(systemName: symbol_name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.black)
                        .background(Color.yellow)
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 4, y: 4)
                } else {
                    Image(systemName: symbol_name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.black)
                        .background(Color.yellow)
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 4, y: 4)
                }
            }
            
            Text(team_name)
                .font(.footnote)
                .foregroundColor(.white)
                .frame(maxWidth: 60)
        }
        
    }
}

struct GroupPic_Previews: PreviewProvider {
    static var previews: some View {
        GroupPic()
    }
}