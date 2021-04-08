//
//  ActiveMembers.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct ActiveMembers: View {
    var body: some View {
        HStack {
            ProfilePic()
                .padding(8)
            ProfilePic()
                .padding(8)
            ProfilePic()
                .padding(8)
        }
        .background(Color.white)
        .cornerRadius(20)
        .clipped()
        .shadow(color: .black, radius: 4, y: 4)

    }
}

struct ActiveMembers_Previews: PreviewProvider {
    static var previews: some View {
        ActiveMembers()
    }
}
