//
//  GroupSidebar.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct GroupSidebar: View {
    var body: some View {
        VStack{
            Text("Groups")
                .font(.title2)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding()
            GroupPic(selected: true)
                .padding()
            
            GroupPic()
                .padding()
            
            GroupPic()
                .padding()
            
            Button{
                // Add group button
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
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
