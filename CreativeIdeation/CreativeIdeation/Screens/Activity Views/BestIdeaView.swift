//
//  BestIdeaView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-10-08.
//

import SwiftUI

struct BestIdeaView: View {

    @Environment(\.colorScheme) var colorScheme

    @State var bestIdea: StickyNote

    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Spacer()

                    Text("The voters have spoken!")
                        .font(.largeTitle)
                        .padding()

                    Text("...and the best idea from this session was:")
                        .font(.title)

                    Spacer()

                    VStack(spacing: 0) {
                        // Header
                        Rectangle()
                            .foregroundColor(colorScheme == .dark ? bestIdea.chosenColor!.darker() : bestIdea.chosenColor!)
                            .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.1)

                        // Text area
                        Text(bestIdea.input)
                            .font(.title)
                            .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.5)
                            .background(colorScheme == .dark ? bestIdea.chosenColor!.darker(by: 15.0) : bestIdea.chosenColor!.lighter(by: 20.0))
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                            .padding(.top, -3)
                    }
                    .cornerRadius(15)
                    .shadow(radius: 4)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct BestIdeaView_Previews: PreviewProvider {
    static var previews: some View {
        BestIdeaView(bestIdea: StickyNote(input: "", itemId: ""))
    }
}
