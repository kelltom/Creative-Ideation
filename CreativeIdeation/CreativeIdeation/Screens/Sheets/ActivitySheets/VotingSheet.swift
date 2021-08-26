//
//  VotingSheet.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-08-16.
//

import SwiftUI

struct VotingSheet: View {

    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel

    @Binding var showSheet: SessionSheet?

    var spinAnimation: Animation {
        Animation.easeInOut
    }

    // Compute the maximum position for the list of remaining vote stickies
    private var maxPos: Int {
        return sessionItemViewModel.votingStickies.map { $0.pos }.max() ?? 0
    }

    /// Return the VotingSticky's width for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - pos: The index position of the sticky note in the votingStickies array
    private func getStickyNoteWidth(_ geometry: GeometryProxy, pos: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(sessionItemViewModel.votingStickies.count - 1 - pos) * 10
        return geometry.size.width - offset
    }

    /// Return the VotingSticky's frame offset for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - pos: The index position of the sticky note in the votingStickies array
    private func getStickyNoteOffset(_ geometry: GeometryProxy, pos: Int) -> CGFloat {
        return  CGFloat(sessionItemViewModel.votingStickies.count - 1 - pos) * 12
    }

    var body: some View {

        VStack {
            GeometryReader { geometry in
                ZStack {

                    Color("BackgroundColor")

                    HStack(spacing: 0) {
                        Spacer()
                        VStack {

                            Spacer()

                            // Title text
                            Text("Voting")
                                .font(.system(size: 40, weight: .heavy))
                                .padding(.top, 50)

                            // Populate stack of votable sticky notes on screen
                            ZStack {
                                ForEach(self.sessionItemViewModel.votingStickies) { sticky in
                                    if sticky.pos > self.maxPos - 4 {
                                        sticky
                                            .animation(.spring())
                                            .frame(width: self.getStickyNoteWidth(geometry, pos: sticky.pos))
                                            .offset(x: 0, y: self.getStickyNoteOffset(geometry, pos: sticky.pos))
                                    }
                                }
                                if sessionItemViewModel.votingStickies.count == 0 {
                                    Text("No Stickies Left to Vote On!")
                                        .font(.title)
                                        .frame(width: self.getStickyNoteWidth(geometry, pos: -2))
                                }
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.5)

                            Spacer()

                            // Vote buttons (alternative to swiping)
                            HStack(spacing: geometry.size.width * 0.15) {
                                // Downvote Button
                                Button {
                                    if sessionItemViewModel.votingStickies.count > 0 {
                                        let topSticky = self.sessionItemViewModel.votingStickies.last!
                                        withAnimation {
                                            self.sessionItemViewModel.castVote(itemId: topSticky.itemId, scoreChange: -1)
                                        }
                                        topSticky.onRemove(topSticky.itemId)
                                    }

                                } label: {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(Color("BackgroundColor"))
                                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)

                                        Circle().stroke(lineWidth: 4)
                                            .foregroundColor(Color.red)
                                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)

                                        Image(systemName: "hand.thumbsdown")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width * 0.075, height: geometry.size.width * 0.075)
                                            .padding(.top, 10)
                                            .foregroundColor(.red)
                                    }
                                    .frame(width: 110, height: 110)
                                    .clipped()
                                    .shadow(radius: 4, y: 4)
                                }

                                // Skip Button
                                Button {
                                    if sessionItemViewModel.votingStickies.count > 0 {
                                        withAnimation {
                                            sessionItemViewModel.clearAnimations()
                                            sessionItemViewModel.showingSkip.toggle()
                                            sessionItemViewModel.setAnimationTimer()
                                        }

                                        let topSticky = self.sessionItemViewModel.votingStickies.last!
                                        topSticky.onRemove(topSticky.itemId)
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(Color("BackgroundColor"))
                                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)

                                        Circle().stroke(lineWidth: 4)
                                            .foregroundColor(Color.gray)
                                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)

                                        Image(systemName: "hand.raised")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width * 0.075, height: geometry.size.width * 0.075)
                                            .padding(.leading, 4)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(width: 110, height: 110)
                                    .clipped()
                                    .shadow(radius: 4, y: 4)
                                }

                                // Upvote Button
                                Button {
                                    if sessionItemViewModel.votingStickies.count > 0 {
                                        let topSticky = self.sessionItemViewModel.votingStickies.last!
                                        withAnimation {
                                            self.sessionItemViewModel.castVote(itemId: topSticky.itemId, scoreChange: 1)
                                        }
                                        topSticky.onRemove(topSticky.itemId)
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(Color("BackgroundColor"))
                                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)

                                        Circle().stroke(lineWidth: 4)
                                            .foregroundColor(Color.green)
                                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)

                                        Image(systemName: "hand.thumbsup")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width * 0.075, height: geometry.size.width * 0.075)
                                            .padding(.bottom, 10)
                                            .foregroundColor(.green)
                                    }
                                    .frame(width: 110, height: 110)
                                    .clipped()
                                    .shadow(radius: 4, y: 4)
                                }
                            }

                            Spacer()
                        }
                        Spacer()
                    }

                    // Animations for Dislike/Skip/Like
                    VStack {
                        Spacer()
                        HStack {
                            if $sessionItemViewModel.showingDislike.wrappedValue {
                                ZStack {
                                    Image(systemName: "burst.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.13, height: geometry.size.width * 0.13)
                                        .padding(.leading, 4)
                                        .foregroundColor(.red)
                                    Text("-1")
                                        .font(.system(size: 50, weight: .heavy))
                                        .foregroundColor(.white)
                                }
                                .rotationEffect(Angle.degrees(sessionItemViewModel.isSpinning ? 10 : -10))
                                .animation(spinAnimation)
                                .transition(.scale(scale: 0.5).animation(.easeInOut(duration: 0.2)))
                            }

                            Spacer()

                            if $sessionItemViewModel.showingSkip.wrappedValue {
                                ZStack {
                                    Text("SKIP")
                                        .font(.system(size: 50, weight: .heavy))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 8)
                                }
                                .transition(.scale(scale: 0.5).animation(.easeInOut(duration: 0.2)))
                            }

                            Spacer()

                            if $sessionItemViewModel.showingLike.wrappedValue {
                                ZStack {
                                    Image(systemName: "burst.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.13, height: geometry.size.width * 0.13)
                                        .padding(.leading, 4)
                                        .foregroundColor(.green)
                                    Text("+1")
                                        .font(.system(size: 50, weight: .heavy))
                                        .foregroundColor(.white)
                                }
                                .rotationEffect(Angle.degrees(sessionItemViewModel.isSpinning ? 10 : -10))
                                .animation(spinAnimation)
                                .transition(.scale(scale: 0.5).animation(.easeInOut(duration: 0.2)))
                            }
                        }
                        .frame(width: geometry.size.width * 0.75)
                        Spacer()
                            .frame(height: geometry.size.width * 0.33)
                    }
                }
            }
        }
        .onAppear {
            // Get list of sticky notes to be voted on
            sessionItemViewModel.populateVotingList()
        }
    }

}

struct VotingSheet_Previews: PreviewProvider {
    static var previews: some View {
        VotingSheet(showSheet: .constant(.voting))
            .environmentObject(SessionItemViewModel())
    }
}