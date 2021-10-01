//
//  TopSticky.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-09-30.
//

import SwiftUI

struct TopSticky: View, Identifiable {

    var id = UUID()

    @Environment(\.colorScheme) var colorScheme

    @State var chosenColor: Color = Color.red
    @State var input: String = "Default Text"
    @State var score: Int = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                ZStack {
                    
                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? chosenColor.darker() : chosenColor)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.17)

                    Text("Score: " + String(score))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("StrokeColor"))

                }

                // Text area
                Text(input)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.75)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.83)
                    .background(colorScheme == .dark ? chosenColor.darker(by: 15.0) : chosenColor.lighter(by: 20.0))
                    .foregroundColor(Color("StrokeColor"))
            }
            .cornerRadius(10)
            .shadow(radius: 4)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center/*@END_MENU_TOKEN@*/)
        }
    }
}

struct TopSticky_Previews: PreviewProvider {
    static var previews: some View {
        TopSticky()
    }
}
