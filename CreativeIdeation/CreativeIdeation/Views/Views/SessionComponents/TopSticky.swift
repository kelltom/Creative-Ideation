//
//  TopSticky.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-09-30.
//

import SwiftUI

struct TopSticky: View, Identifiable {

    var id = UUID()

    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sessionSettingsViewModel: SessionSettingsViewModel
    @Environment(\.colorScheme) var colorScheme

    @State var itemId: String = ""
    @State var chosenColor: Color = Color.red
    @State var input: String = "Default Text"
    @State var score: Int = 0

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    // Header
                    ZStack {
                        Rectangle()
                            .foregroundColor(colorScheme == .dark ? chosenColor.darker() : chosenColor)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.15)

                        if sessionSettingsViewModel.settings.last!.displayScore {
                            Text("Score: " + String(score))
                                .font(.title)
                                .fontWeight(.bold)
                            .foregroundColor(Color("StrokeColor"))
                        }
                    }

                    // Text area
                    Text(input)
                        .frame(width: geometry.size.width * 0.97, height: geometry.size.height * 0.65)
                        .frame(width: geometry.size.width)
                        .background(colorScheme == .dark ? chosenColor.darker(by: 15.0) : chosenColor.lighter(by: 20.0))
                        .foregroundColor(Color("StrokeColor"))
                        .padding(.top, -3)

                    Button {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            sessionViewModel.castFinalVote(itemId: itemId)
                        }
                    } label: {
                        Text("Vote")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("StrokeColor"))
                            .frame(width: geometry.size.width, height: geometry.size.width * 0.2)
                            .background(colorScheme == .dark ? chosenColor.darker() : chosenColor)
                    }
                }
                .cornerRadius(15)
                .shadow(radius: 4)
            }
        }
    }
}

struct TopSticky_Previews: PreviewProvider {
    static var previews: some View {
        TopSticky()
    }
}
