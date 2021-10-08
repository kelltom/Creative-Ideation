//
//  TopVotedView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-10-07.
//

import SwiftUI

struct TopVotedView: View {

    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sessionSettingsViewModel: SessionSettingsViewModel
    @Environment(\.colorScheme) var colorScheme

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())]

    var body: some View {
        // Display results of the voting
        GeometryReader { geometry in
            if sessionViewModel.didCastFinalVote() {
                HStack {
                    VStack {
                        Spacer()

                        Text("You've cast your vote!")
                            .font(.largeTitle)
                        .padding()

                        Text("Time to wait and see which idea comes out on top!")
                            .font(.title)

                        Spacer()

                        VStack(spacing: 0) {
                            // Header
                            Rectangle()
                                .foregroundColor(colorScheme == .dark ? Color.white.darker() : Color.black)
                                .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.1)

                            // Text area
                            Text("?")
                                .font(.system(size: 64, weight: .heavy))
                                .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.5)
                                .background(colorScheme == .dark ? Color.white.darker(by: 15.0) : Color.black.lighter(by: 20.0))
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

            } else {
                VStack {
                    Text("Voting Has Finished!")
                        .font(.largeTitle)
                        .padding(.top)

                    Text("Now it's time to pick a favourite!")
                        .font(.title)
                        .padding()

                    LazyVGrid(columns: columns, spacing: geometry.size.width * 0.08) {
                        ForEach(self.sessionItemViewModel.stickyNotes) { sticky in
                            TopSticky(itemId: sticky.itemId, chosenColor: sticky.chosenColor!, input: sticky.input, score: sticky.score)
                                .frame(width: geometry.size.width * 0.33, height: geometry.size.width * 0.28)
                        }
                    }
                }
            }
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    sessionItemViewModel.sortStickies(sortBy: .score)
//                    sessionItemViewModel.getTopStickies(spots: 6)
//                }
//            }
        }
    }
}

struct TopVotedView_Previews: PreviewProvider {
    static var previews: some View {
        TopVotedView()
    }
}
