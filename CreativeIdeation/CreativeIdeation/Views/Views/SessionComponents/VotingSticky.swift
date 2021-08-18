//
//  VotingSticky.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-08-16.
//

import SwiftUI

/// Represents a sticky note within the Voting sheet
struct VotingSticky: View, Identifiable {
    var id = UUID()

    @State var itemId: String = "123"
    @State var chosenColor: Color = Color.red
    @State var input: String = "Text"
    @State var pos: Int = 0  // the position of the sticky note in the list

    @State private var translation: CGSize = .zero

    var onRemove: (_ id: String) -> Void

    var thresholdPercentage: CGFloat = 0.5 // when the user has draged 50% the width of the screen in either direction

    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                Rectangle()
                    .foregroundColor(chosenColor)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.05)

                // Text area
                Text(input)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.25)
                    .background(chosenColor.lighter())
                    .foregroundColor(Color("StrokeColor"))
            }
            .cornerRadius(10)
            .shadow(radius: 4)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center/*@END_MENU_TOKEN@*/)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                    }.onEnded { value in
                        if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                            self.onRemove(self.itemId)
                        } else {
                            self.translation = .zero
                        }
                    }
            )
        }
    }
}

struct VotingSticky_Previews: PreviewProvider {
    static var previews: some View {
        VotingSticky(itemId: "123", chosenColor: Color.red, input: "Test", pos: 2, onRemove: { _ in
            // do nothing
        })
    }
}
