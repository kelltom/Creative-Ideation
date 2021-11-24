//
//  ProfilePic.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct ProfilePic: View {

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel

    var size: CGFloat = 45
    // var image: String = "person.fill"

    var body: some View {
        Text(userAccountViewModel.selectedUser?.name.prefix(1) ?? "?")
            .font(.title)
            .frame(width: size, height: size)
            .foregroundColor(Color("StrokeColor"))
            .background(Color("BackgroundColor"))
            .clipShape(Circle())
            .onAppear {
                userAccountViewModel.getCurrentUserInfo()
            }
    }
}

struct ProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePic()
    }
}
