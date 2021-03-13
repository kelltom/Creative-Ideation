//
//  GroupMemberPanel.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct GroupMemberPanel: View {
    var body: some View {
        HStack(spacing: 0){
            ProfilePic()
                .padding(8)
            ProfilePic()
                .padding(8)
            ProfilePic()
                .padding(8)
            
            Text("+4 More...")
                .foregroundColor(.gray)
                .padding(8)
        }
        .frame(minWidth: 300)
        .background(Color.white)
        .clipped()
        .shadow(color: .black, radius: 4, y: 4)
    }
}

struct GroupMemberPanel_Previews: PreviewProvider {
    static var previews: some View {
        GroupMemberPanel()
    }
}
