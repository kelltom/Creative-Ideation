//
//  TeamPic.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

struct PreferencePic: View {

    var selected: Bool = false
    var symbolName: String = "person.fill"
    var teamName: String = "Name"

    var body: some View {
        VStack {
            Button {
                // select group
            } label: {
                if selected {
                    Image(systemName: symbolName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.black)
                        .background(Color.yellow)
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 4, y: 4)
                } else {
                    Image(systemName: symbolName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.black)
                        .background(Color.yellow)
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 4, y: 4)
                }
            }

            Text(teamName)
                .font(.footnote)
                .foregroundColor(.white)
                .frame(maxWidth: 60)
        }

    }
}

struct TeamPic_Previews: PreviewProvider {
    static var previews: some View {
        PreferencePic()
    }
}
