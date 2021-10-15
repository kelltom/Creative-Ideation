//
//  BestIdea.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-10-15.
//

import SwiftUI

struct BestIdea: View {

    @Environment(\.colorScheme) var colorScheme

    @State var chosenColor = Color.red
    @State var input = ""

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                Rectangle()
                    .foregroundColor(colorScheme == .dark ? chosenColor.darker() : chosenColor)
                    .frame(width: geometry.size.width, height: geometry.size.width * 0.2)

                // Text area
                Text(input)
                    .font(.title)
                    .frame(width: geometry.size.width, height: geometry.size.width * 0.8)
                    .background(colorScheme == .dark ? chosenColor.darker(by: 15.0) : chosenColor.lighter(by: 20.0))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .padding(.top, -3)
            }
            .cornerRadius(15)
            .shadow(radius: 4)
        }
    }
}

struct BestIdea_Previews: PreviewProvider {
    static var previews: some View {
        BestIdea()
    }
}
