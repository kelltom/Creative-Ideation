//
//  ProfilePic.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct ProfilePic: View {

    var size: CGFloat = 45
    var image: String = "person.fill"

    var body: some View {
        Image(systemName: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundColor(Color.black)
            .background(Color.gray)
            .clipShape(Circle())
    }
}

struct ProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePic()
    }
}
