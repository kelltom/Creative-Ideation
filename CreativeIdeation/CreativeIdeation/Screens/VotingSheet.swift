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
            if sessionItemViewModel.votingStickies.count != 0 {
                GeometryReader { geometry in

                    VStack {
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
                                        .frame(width: self.getStickyNoteWidth(geometry, pos: sticky.pos), height: geometry.size.height * 0.7)
                                        .offset(x: 0, y: self.getStickyNoteOffset(geometry, pos: sticky.pos))
                                }
                            }
                        }

                        // Vote buttons (alternative to swiping)
                        HStack(spacing: 95) {
                            // Downvote Button
                            Button {

                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color("BackgroundColor"))
                                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.3)

                                    Circle().stroke(lineWidth: 4)
                                        .foregroundColor(Color.red)
                                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.3)

                                    Image(systemName: "hand.thumbsdown")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.075, height: geometry.size.height * 0.15)
                                        .padding(.top, 10)
                                        .foregroundColor(.red)
                                }
                                .frame(width: 110, height: 110)
                                .clipped()
                                .shadow(radius: 4, y: 4)
                            }

                            // Skip Button
                            Button {

                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color("BackgroundColor"))
                                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.3)

                                    Circle().stroke(lineWidth: 4)
                                        .foregroundColor(Color.gray)
                                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.3)

                                    Image(systemName: "hand.raised")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.075, height: geometry.size.height * 0.15)
                                        .padding(.leading, 4)
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 110, height: 110)
                                .clipped()
                                .shadow(radius: 4, y: 4)
                            }

                            // Upvote Button
                            Button {

                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color("BackgroundColor"))
                                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.3)

                                    Circle().stroke(lineWidth: 4)
                                        .foregroundColor(Color.green)
                                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.3)

                                    Image(systemName: "hand.thumbsup")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.075, height: geometry.size.height * 0.15)
                                        .padding(.bottom, 10)
                                        .foregroundColor(.green)
                                }
                                .frame(width: 110, height: 110)
                                .clipped()
                                .shadow(radius: 4, y: 4)
                            }
                        }
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
