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

    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Environment(\.colorScheme) var colorScheme

    @State var itemId: String = "Default ID"  // itemId corresponds to sessionItem's ID in the database
    @State var chosenColor: Color = Color.red
    @State var input: String = "Default Text"
    @State var pos: Int = 0  // the position of the sticky note in the list
    @State var scoreChange = 0

    @State private var translation: CGSize = .zero  // horizontal translation of sticky when swiping

    var onRemove: (_ id: String) -> Void  // declare function to remove swiped sticky from list (see SessionItemViewModel.populateVotingList())

    var thresholdPercentage: CGFloat = 0.35  // when the user has dragged 50% the width of the screen in either direction

    /// What percentage of our own width have we swiped
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
                    .foregroundColor(colorScheme == .dark ? chosenColor.darker() : chosenColor)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.1)

                // Text area
                Text(input)
                    .font(.largeTitle)
                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.45)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                    .background(colorScheme == .dark ? chosenColor.darker(by: 15.0) : chosenColor.lighter(by: 20.0))
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
                        // after swipe ends, determine if far enough to remove sticky
                        if self.getGesturePercentage(geometry, from: value) > self.thresholdPercentage {
                            // Upvote, raising score of sticky by 1
                            withAnimation {
                                self.sessionItemViewModel.castVote(itemId: self.itemId, scoreChange: 1)
                            }
                            self.onRemove(self.itemId)
                            sessionItemViewModel.votedOnStack[sessionItemViewModel.votedOnStack.count - 1].1 = 1
                            sessionViewModel.updateDateModified()

                        } else if self.getGesturePercentage(geometry, from: value) < -self.thresholdPercentage {
                            // Downvote, lowering score of sticky by 1
                            withAnimation {
                                self.sessionItemViewModel.castVote(itemId: self.itemId, scoreChange: -1)
                            }
                            self.onRemove(self.itemId)
                            sessionItemViewModel.votedOnStack[sessionItemViewModel.votedOnStack.count - 1].1 = -1
                            sessionViewModel.updateDateModified()

                        } else {
                            // return sticky to center position
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
        .preferredColorScheme(.dark)
    }
}
