//
//  SubGroup.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct GroupButton: View {

    var title: String = "Example"
    var selected: Bool = false

    var body: some View {
        if selected {
            ZStack {
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 140, alignment: .center)
                }

            }
            .frame(width: 200, height: 80)
            .background(Color("brandPrimary"))
            .cornerRadius(25)
        } else {
            ZStack {
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 140, alignment: .center)
                }

            }
            .frame(width: 200, height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: 25.0/*@END_MENU_TOKEN@*/)
                    .strokeBorder(Color("brandPrimary"), lineWidth: 2)
            )
        }
    }
}

struct SubGroup_Previews: PreviewProvider {
    static var previews: some View {
        GroupButton(title: "Example", selected: true)
    }
}
