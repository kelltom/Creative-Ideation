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
    @State private var stickies: [VotingSticky] = []

    // Compute what the max ID in the given users array is.
    private var maxPos: Int {
        return self.stickies.map { $0.pos }.max() ?? 0
    }

    /// Return the CardViews width for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - pos: The position of the sticky in the list
    private func getStickyNoteWidth(_ geometry: GeometryProxy, pos: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(stickies.count - 1 - pos) * 10
        return geometry.size.width - offset
    }

    /// Return the CardViews frame offset for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - pos: The position of the sticky in the list
    private func getStickyNoteOffset(_ geometry: GeometryProxy, pos: Int) -> CGFloat {
        return  CGFloat(stickies.count - 1 - pos) * 10
    }

    var body: some View {

        HStack {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        // Populate stack of sticky notes on screen
                        ForEach(self.sessionItemViewModel.votingStickies) { sticky in
                            if (self.maxPos - 3)...self.maxPos ~= sticky.pos {
                                sticky
                                    .frame(width: self.getStickyNoteWidth(geometry, pos: sticky.pos), height: geometry.size.height)
                                    .offset(x: 0, y: self.getStickyNoteOffset(geometry, pos: sticky.pos))
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
